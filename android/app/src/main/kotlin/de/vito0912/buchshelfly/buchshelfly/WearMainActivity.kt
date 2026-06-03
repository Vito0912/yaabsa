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
import java.util.concurrent.TimeUnit

class WearMainActivity : AudioServiceActivity() {

    companion object {
        private const val CHANNEL = "de.vito0912.yaabsa/wear_data"
        private const val TAG = "WearDataLayer"
        private const val REQ_PATH = "/yaabsa/credential_request"
        private const val RESP_PATH = "/yaabsa/credential_response"
        private const val TIMEOUT = 30L
    }

    private var channel: MethodChannel? = null
    private var messageClient: MessageClient? = null
    private var receivedUrl: String? = null
    private var receivedToken: String? = null

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
        Thread {
            try {
                val nodes = Tasks.await(Wearable.getNodeClient(this).connectedNodes, TIMEOUT, TimeUnit.SECONDS)
                if (nodes.isEmpty()) { handler.post { result.error("NO_PHONE", "No connected phone found", null) }; return@Thread }
                val nodeId = nodes[0].id
                val requestId = java.util.UUID.randomUUID().toString()
                Tasks.await(messageClient!!.sendMessage(nodeId, REQ_PATH, requestId.toByteArray()), TIMEOUT, TimeUnit.SECONDS)
                Log.d(TAG, "Credential request sent: $requestId")

                // Listen for response
                messageClient!!.addListener { event: MessageEvent ->
                    if (event.path == RESP_PATH) {
                        val parts = String(event.data).split("|", limit = 3)
                        if (parts.size >= 2) { receivedUrl = parts[0]; receivedToken = parts[1] }
                    }
                }

                val start = System.currentTimeMillis()
                while (receivedUrl == null && receivedToken == null) {
                    if (System.currentTimeMillis() - start > TIMEOUT * 1000) { handler.post { result.error("TIMEOUT", "Timed out", null) }; return@Thread }
                    Thread.sleep(500)
                }
                handler.post { result.success(mapOf("serverUrl" to receivedUrl, "token" to receivedToken)) }
            } catch (e: Exception) {
                Log.e(TAG, "Failed: ${e.message}")
                handler.post { result.error("FAILED", e.message, null) }
            }
        }.start()
    }
}
