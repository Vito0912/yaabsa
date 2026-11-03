package de.vito0912.yaabsa

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import com.google.android.gms.tasks.Task
import com.google.android.gms.tasks.Tasks
import com.google.android.gms.wearable.CapabilityClient
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.Wearable
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.util.UUID
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

class WearMainActivity : AudioServiceActivity() {

    companion object {
        private const val CHANNEL = "de.vito0912.yaabsa/wear_data"
        private const val TAG = "WearDataLayer"
        private const val REQ_PATH = "/yaabsa/credential_request"
        private const val RESP_PATH = "/yaabsa/credential_response"
        // Advertised by the phone app (res/values/wear.xml).
        private const val PHONE_CAPABILITY = "yaabsa_wear_pairing"
        // Pseudo-node for the cloud relay; listed as connected when Bluetooth is
        // down, but no app receives messages sent to it.
        private const val CLOUD_NODE_ID = "cloud"
        private const val CONNECT_TIMEOUT = 30L
        // The user has to log in on the phone, so the response can take much
        // longer than a network round-trip.
        private const val LOGIN_TIMEOUT = 300L
    }

    private var channel: MethodChannel? = null
    private var messageClient: MessageClient? = null
    private var flutterUiDisplayed = false

    private val handler = Handler(Looper.getMainLooper())
    private var pendingPairing: PairingRequest? = null

    private class PairingRequest(val result: MethodChannel.Result) {
        val response = CountDownLatch(1)
        var credentials: Map<String, Any?>? = null
        lateinit var worker: Thread
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen().setKeepOnScreenCondition { !flutterUiDisplayed }
        super.onCreate(savedInstanceState)
        messageClient = Wearable.getMessageClient(this)
    }

    override fun onFlutterUiDisplayed() {
        super.onFlutterUiDisplayed()
        flutterUiDisplayed = true
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "requestCredentials" -> requestCredentials(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun requestCredentials(result: MethodChannel.Result) {
        if (pendingPairing != null) {
            result.error("PAIRING_IN_PROGRESS", "A pairing request is already in progress", null)
            return
        }

        val client = messageClient
        if (client == null) {
            result.error("UNAVAILABLE", "Pairing is unavailable", null)
            return
        }

        val request = PairingRequest(result)
        val requestId = UUID.randomUUID().toString()

        val listener = MessageClient.OnMessageReceivedListener { event: MessageEvent ->
            if (event.path == RESP_PATH) {
                try {
                    val json = JSONObject(String(event.data))
                    if (json.optString("requestId") != requestId) {
                        return@OnMessageReceivedListener
                    }
                    val serverUrl = json.optString("serverUrl")
                    val accessToken = json.optString("accessToken")
                    if (serverUrl.isNotEmpty() && accessToken.isNotEmpty()) {
                        // Custom headers the server needs (e.g. reverse-proxy auth).
                        val headersJson = json.optJSONObject("headers")
                        val headers = headersJson?.keys()?.asSequence()?.associateWith { headersJson.getString(it) }
                        request.credentials = mapOf(
                            "serverUrl" to serverUrl,
                            "accessToken" to accessToken,
                            "refreshToken" to json.optString("refreshToken").ifEmpty { null },
                            "headers" to headers,
                        )
                        request.response.countDown()
                    }
                } catch (e: Exception) {
                    Log.w(TAG, "Ignoring malformed credential response: ${e.message}")
                }
            }
        }

        request.worker = Thread {
            var registration: Task<Void>? = null

            try {
                val nodeIds = findPhoneNodes()
                ensurePairingActive()

                if (nodeIds.isEmpty()) {
                    completePairing(request) {
                        it.error("NO_PHONE", "No connected phone found", null)
                    }
                    return@Thread
                }

                registration = client.addListener(listener)
                Tasks.await(registration, CONNECT_TIMEOUT, TimeUnit.SECONDS)
                ensurePairingActive()

                var sent = false
                var lastError: Exception? = null
                for (nodeId in nodeIds) {
                    ensurePairingActive()

                    try {
                        Tasks.await(
                            client.sendMessage(nodeId, REQ_PATH, requestId.toByteArray()),
                            CONNECT_TIMEOUT,
                            TimeUnit.SECONDS,
                        )
                        sent = true
                        Log.d(TAG, "Credential request $requestId sent to $nodeId")
                        break
                    } catch (e: InterruptedException) {
                        throw e
                    } catch (e: Exception) {
                        lastError = e
                        Log.w(TAG, "Sending credential request to $nodeId failed: ${e.message}")
                    }
                }

                if (!sent) {
                    throw lastError ?: IllegalStateException("Credential request could not be sent")
                }

                val success = request.response.await(LOGIN_TIMEOUT, TimeUnit.SECONDS)
                val credentials = request.credentials
                ensurePairingActive()

                completePairing(request) {
                    if (success && credentials != null) {
                        it.success(credentials)
                    } else {
                        it.error("TIMEOUT", "Timed out waiting for phone response", null)
                    }
                }
            } catch (e: InterruptedException) {
                Thread.currentThread().interrupt()
                completePairing(request) {
                    it.error("CANCELLED", "Pairing cancelled", null)
                }
            } catch (e: Exception) {
                Log.e(TAG, "Failed: ${e.message}")
                completePairing(request) {
                    it.error("FAILED", e.message, null)
                }
            } finally {
                // Registration can finish after an interrupted or timed-out await.
                registration?.addOnCompleteListener {
                    client.removeListener(listener)
                }
            }
        }

        pendingPairing = request
        request.worker.start()
    }

    private fun ensurePairingActive() {
        if (Thread.currentThread().isInterrupted) {
            throw InterruptedException()
        }
    }

    private fun completePairing(request: PairingRequest, complete: (MethodChannel.Result) -> Unit) {
        handler.post {
            if (pendingPairing !== request) {
                return@post
            }

            pendingPairing = null
            complete(request.result)
        }
    }

    override fun onDestroy() {
        channel?.setMethodCallHandler(null)
        channel = null

        val request = pendingPairing
        pendingPairing = null
        request?.worker?.interrupt()
        request?.result?.error("CANCELLED", "Pairing cancelled", null)

        handler.removeCallbacksAndMessages(null)
        messageClient = null
        super.onDestroy()
    }

    /**
     * Nodes running the phone app, nearby ones first. Falls back to every
     * connected node except the cloud relay for phone builds that predate the
     * capability.
     */
    private fun findPhoneNodes(): List<String> {
        try {
            val capability = Tasks.await(
                Wearable.getCapabilityClient(this).getCapability(PHONE_CAPABILITY, CapabilityClient.FILTER_REACHABLE),
                CONNECT_TIMEOUT,
                TimeUnit.SECONDS,
            )
            val nodes = capability.nodes.sortedByDescending { it.isNearby }
            if (nodes.isNotEmpty()) {
                return nodes.map { it.id }
            }
        } catch (e: InterruptedException) {
            throw e
        } catch (e: Exception) {
            Log.w(TAG, "Capability lookup failed: ${e.message}")
        }

        val connected = Tasks.await(Wearable.getNodeClient(this).connectedNodes, CONNECT_TIMEOUT, TimeUnit.SECONDS)
        return connected.filter { it.id != CLOUD_NODE_ID }.sortedByDescending { it.isNearby }.map { it.id }
    }
}
