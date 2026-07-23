package de.vito0912.yaabsa

import android.content.ComponentName
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.support.v4.media.MediaBrowserCompat
import android.support.v4.media.session.MediaControllerCompat
import android.support.v4.media.session.PlaybackStateCompat

object WidgetMediaSessionObserver {
    private var appContext: Context? = null
    private var mediaBrowser: MediaBrowserCompat? = null
    private var mediaController: MediaControllerCompat? = null
    private var isConnecting = false

    private val mainHandler = Handler(Looper.getMainLooper())
    private var reconnectRunnable: Runnable? = null

    private val mediaControllerCallback = object : MediaControllerCompat.Callback() {
        override fun onPlaybackStateChanged(state: PlaybackStateCompat?) {
            val context = appContext ?: return
            WidgetUpdateDispatcher.updatePlayerWidgets(context)
            WidgetUpdateDispatcher.updateQuickPlayWidgets(context)
        }

        override fun onMetadataChanged(metadata: android.support.v4.media.MediaMetadataCompat?) {
            val context = appContext ?: return
            WidgetUpdateDispatcher.updatePlayerWidgets(context)
            WidgetUpdateDispatcher.updateQuickPlayWidgets(context)
        }

        override fun onSessionDestroyed() {
            scheduleReconnect()
        }
    }

    fun ensureConnected(context: Context) {
        val localContext = context.applicationContext
        if (!WidgetRuntimeSupport.isWidgetSupportEnabled(localContext)) {
            clearController()
            return
        }

        appContext = localContext

        if (mediaController != null || isConnecting) {
            return
        }

        connect(localContext)
    }

    private fun connect(context: Context) {
        isConnecting = true

        val serviceComponent = ComponentName(context, "com.ryanheise.audioservice.AudioService")
        mediaBrowser = MediaBrowserCompat(
            context,
            serviceComponent,
            object : MediaBrowserCompat.ConnectionCallback() {
                override fun onConnected() {
                    isConnecting = false
                    val browser = mediaBrowser ?: return

                    try {
                        val controller = MediaControllerCompat(context, browser.sessionToken)
                        mediaController?.unregisterCallback(mediaControllerCallback)
                        mediaController = controller
                        controller.registerCallback(mediaControllerCallback)

                        WidgetUpdateDispatcher.updatePlayerWidgets(context)
                        WidgetUpdateDispatcher.updateQuickPlayWidgets(context)
                    } catch (_: Exception) {
                        clearController()
                    }
                }

                override fun onConnectionSuspended() {
                    isConnecting = false
                    clearController()
                    scheduleReconnect()
                }

                override fun onConnectionFailed() {
                    isConnecting = false
                    clearController()
                    scheduleReconnect()
                }
            },
            null
        ).also { browser ->
            try {
                browser.connect()
            } catch (_: Exception) {
                isConnecting = false
                clearController()
                scheduleReconnect()
            }
        }
    }

    private fun clearController() {
        reconnectRunnable?.let { mainHandler.removeCallbacks(it) }
        reconnectRunnable = null

        mediaController?.unregisterCallback(mediaControllerCallback)
        mediaController = null

        runCatching { mediaBrowser?.disconnect() }
        mediaBrowser = null
    }

    private fun scheduleReconnect() {
        val context = appContext ?: return
        if (!WidgetRuntimeSupport.isWidgetSupportEnabled(context)) {
            clearController()
            return
        }

        reconnectRunnable?.let { mainHandler.removeCallbacks(it) }
        reconnectRunnable = Runnable {
            if (mediaController == null && !isConnecting) {
                connect(context)
            }
        }

        mainHandler.postDelayed(reconnectRunnable!!, 1200L)
    }
}
