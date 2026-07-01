package de.vito0912.yaabsa

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.google.android.gms.tasks.Tasks
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
        private const val CONNECT_TIMEOUT = 30L
        // The user has to log in on the phone, so the response can take much
        // longer than a network round-trip.
        private const val LOGIN_TIMEOUT = 300L
    }

    private var channel: MethodChannel? = null
    private var messageClient: MessageClient? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        messageClient = Wearable.getMessageClient(this)
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
        val handler = Handler(Looper.getMainLooper())
        val latch = CountDownLatch(1)
        val requestId = UUID.randomUUID().toString()
        var received: Map<String, String?>? = null

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
                        received = mapOf(
                            "serverUrl" to serverUrl,
                            "accessToken" to accessToken,
                            "refreshToken" to json.optString("refreshToken").ifEmpty { null },
                        )
                        latch.countDown()
                    }
                } catch (e: Exception) {
                    Log.w(TAG, "Ignoring malformed credential response: ${e.message}")
                }
            }
        }

        Thread {
            try {
                val nodes = Tasks.await(Wearable.getNodeClient(this).connectedNodes, CONNECT_TIMEOUT, TimeUnit.SECONDS)
                if (nodes.isEmpty()) {
                    handler.post { result.error("NO_PHONE", "No connected phone found", null) }
                    return@Thread
                }
                val nodeId = nodes[0].id

                // Register listener BEFORE sending the request to avoid race condition
                messageClient!!.addListener(listener)

                try {
                    Tasks.await(messageClient!!.sendMessage(nodeId, REQ_PATH, requestId.toByteArray()), CONNECT_TIMEOUT, TimeUnit.SECONDS)
                    Log.d(TAG, "Credential request sent: $requestId")

                    val success = latch.await(LOGIN_TIMEOUT, TimeUnit.SECONDS)
                    val credentials = received
                    if (success && credentials != null) {
                        handler.post { result.success(credentials) }
                    } else {
                        handler.post { result.error("TIMEOUT", "Timed out waiting for phone response", null) }
                    }
                } finally {
                    messageClient!!.removeListener(listener)
                }
            } catch (e: Exception) {
                Log.e(TAG, "Failed: ${e.message}")
                messageClient?.removeListener(listener)
                handler.post { result.error("FAILED", e.message, null) }
            }
        }.start()
    }
}
