package de.vito0912.yaabsa

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.support.v4.media.MediaBrowserCompat
import android.support.v4.media.MediaDescriptionCompat
import android.support.v4.media.MediaMetadataCompat
import android.support.v4.media.session.MediaControllerCompat
import android.support.v4.media.session.PlaybackStateCompat
import androidx.media.session.MediaButtonReceiver

object WidgetMediaBridge {
    const val ACTION_PLAYER_TOGGLE = "de.vito0912.yaabsa.widget.action.PLAYER_TOGGLE"
    const val ACTION_PLAYER_NEXT = "de.vito0912.yaabsa.widget.action.PLAYER_NEXT"
    const val ACTION_PLAYER_PREVIOUS = "de.vito0912.yaabsa.widget.action.PLAYER_PREVIOUS"
    const val ACTION_PLAYER_REWIND = "de.vito0912.yaabsa.widget.action.PLAYER_REWIND"
    const val ACTION_PLAYER_FAST_FORWARD = "de.vito0912.yaabsa.widget.action.PLAYER_FAST_FORWARD"
    const val ACTION_PLAYER_STOP = "de.vito0912.yaabsa.widget.action.PLAYER_STOP"
    const val ACTION_QUICK_PLAY = "de.vito0912.yaabsa.widget.action.QUICK_PLAY"
    const val ACTION_SHELF_ITEM = "de.vito0912.yaabsa.widget.action.SHELF_ITEM"

    const val EXTRA_APP_WIDGET_ID = "extra_app_widget_id"
    const val EXTRA_MEDIA_ID = "extra_media_id"
    const val EXTRA_WIDGET_MEDIA_ID_TO_PLAY = "extra_widget_media_id_to_play"
    const val EXTRA_WIDGET_QUICK_PLAY = "extra_widget_quick_play"

    const val CUSTOM_ACTION_PLAY_LAST = "widget.play_last"
    const val CUSTOM_ACTION_REWIND = "aa.custom.rewind"
    const val CUSTOM_ACTION_FAST_FORWARD = "aa.custom.fast_forward"

    data class NowPlayingState(
        val title: String,
        val subtitle: String?,
        val isPlaying: Boolean,
        val artwork: Bitmap?
    )

    fun requestNowPlaying(context: Context, onResult: (NowPlayingState?) -> Unit) {
        withMediaController(
            context = context,
            onConnected = { controller ->
                val metadata = controller.metadata
                val playbackState = controller.playbackState
                val description = metadata?.description

                val title = description.resolveTitle(metadata)
                val subtitle = description.resolveSubtitle(metadata)
                val isPlaying = playbackState.isPlaying
                val artwork = description?.iconBitmap
                    ?: metadata?.getBitmap(MediaMetadataCompat.METADATA_KEY_ART)
                    ?: metadata?.getBitmap(MediaMetadataCompat.METADATA_KEY_ALBUM_ART)

                if (title == "Nothing playing" || title.isEmpty()) {
                    onResult(null)
                } else {
                    onResult(
                        NowPlayingState(
                            title = title,
                            subtitle = subtitle,
                            isPlaying = isPlaying,
                            artwork = artwork
                        )
                    )
                }
            },
            onUnavailable = {
                onResult(null)
            }
        )
    }

    fun performTransportAction(
        context: Context,
        action: String,
        allowLaunchFallback: Boolean = true,
        onDispatched: () -> Unit = {},
    ) {
        withMediaController(
            context = context,
            onConnected = { controller ->
                val state = controller.playbackState
                val controls = controller.transportControls
                when (action) {
                    ACTION_PLAYER_TOGGLE -> {
                        if (state != null && state.isPlaying) {
                            WidgetStorage.setPlaybackLoading(context, false)
                            WidgetUpdateDispatcher.updatePlayerWidgets(context)
                            WidgetUpdateDispatcher.updateQuickPlayWidgets(context)
                            controls.pause()
                        } else {
                            controls.play()
                        }
                    }

                    ACTION_PLAYER_NEXT -> controls.skipToNext()
                    ACTION_PLAYER_PREVIOUS -> controls.skipToPrevious()
                    ACTION_PLAYER_REWIND -> controls.sendCustomAction(CUSTOM_ACTION_REWIND, Bundle.EMPTY)
                    ACTION_PLAYER_FAST_FORWARD -> controls.sendCustomAction(CUSTOM_ACTION_FAST_FORWARD, Bundle.EMPTY)
                    ACTION_PLAYER_STOP -> controls.stop()
                    ACTION_QUICK_PLAY -> controls.sendCustomAction(CUSTOM_ACTION_PLAY_LAST, Bundle.EMPTY)
                }
            },
            onUnavailable = {
                if (action == ACTION_QUICK_PLAY || action == ACTION_PLAYER_TOGGLE) {
                    if (allowLaunchFallback) {
                        launchAppForQuickPlay(context)
                    }
                    return@withMediaController
                }

                fallbackAction(context, action)
            },
            onFinished = onDispatched,
        )
    }

    fun playFromMediaId(
        context: Context,
        mediaId: String,
        allowLaunchFallback: Boolean = true,
        onDispatched: () -> Unit = {},
    ) {
        withMediaController(
            context = context,
            onConnected = { controller ->
                controller.transportControls.playFromMediaId(mediaId, Bundle.EMPTY)
            },
            onUnavailable = {
                if (allowLaunchFallback) {
                    launchAppForMediaId(context, mediaId)
                } else {
                    fallbackAction(context, ACTION_PLAYER_TOGGLE)
                }
            },
            onFinished = onDispatched,
        )
    }

    private fun fallbackAction(context: Context, action: String) {
        val playbackAction = when (action) {
            ACTION_PLAYER_TOGGLE -> PlaybackStateCompat.ACTION_PLAY_PAUSE
            ACTION_PLAYER_NEXT -> PlaybackStateCompat.ACTION_SKIP_TO_NEXT
            ACTION_PLAYER_PREVIOUS -> PlaybackStateCompat.ACTION_SKIP_TO_PREVIOUS
            ACTION_PLAYER_REWIND -> PlaybackStateCompat.ACTION_REWIND
            ACTION_PLAYER_FAST_FORWARD -> PlaybackStateCompat.ACTION_FAST_FORWARD
            ACTION_PLAYER_STOP -> PlaybackStateCompat.ACTION_STOP
            else -> null
        }

        if (playbackAction != null) {
            try {
                MediaButtonReceiver.buildMediaButtonPendingIntent(context, playbackAction)?.send()
            } catch (_: Exception) {
                // Ignore fallback errors to keep widget interactions non-fatal.
            }
        }
    }

    private fun launchAppForMediaId(context: Context, mediaId: String) {
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName) ?: return
        launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        launchIntent.putExtra(EXTRA_WIDGET_MEDIA_ID_TO_PLAY, mediaId)
        context.startActivity(launchIntent)
    }

    private fun launchAppForQuickPlay(context: Context) {
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName) ?: return
        launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        launchIntent.putExtra(EXTRA_WIDGET_QUICK_PLAY, true)
        context.startActivity(launchIntent)
    }

    private fun withMediaController(
        context: Context,
        onConnected: (MediaControllerCompat) -> Unit,
        onUnavailable: () -> Unit,
        onFinished: () -> Unit = {},
    ) {
        val appContext = context.applicationContext
        val serviceComponent = ComponentName(appContext, "com.ryanheise.audioservice.AudioService")

        val handler = Handler(Looper.getMainLooper())
        var browser: MediaBrowserCompat? = null
        var completed = false

        val timeoutRunnable = Runnable {
            if (!completed) {
                completed = true
                try {
                    onUnavailable()
                } finally {
                    runCatching { browser?.disconnect() }
                    onFinished()
                }
            }
        }

        browser = MediaBrowserCompat(
            appContext,
            serviceComponent,
            object : MediaBrowserCompat.ConnectionCallback() {
                override fun onConnected() {
                    handler.removeCallbacks(timeoutRunnable)
                    if (completed) return
                    completed = true

                    val localBrowser = browser
                    if (localBrowser == null) {
                        try {
                            onUnavailable()
                        } finally {
                            onFinished()
                        }
                        return
                    }

                    try {
                        val token = localBrowser.sessionToken
                        val controller = MediaControllerCompat(appContext, token)
                        onConnected(controller)
                    } catch (_: Exception) {
                        onUnavailable()
                    } finally {
                        runCatching { localBrowser.disconnect() }
                        onFinished()
                    }
                }

                override fun onConnectionSuspended() {
                    handler.removeCallbacks(timeoutRunnable)
                    if (completed) return
                    completed = true
                    try {
                        onUnavailable()
                    } finally {
                        runCatching { browser?.disconnect() }
                        onFinished()
                    }
                }

                override fun onConnectionFailed() {
                    handler.removeCallbacks(timeoutRunnable)
                    if (completed) return
                    completed = true
                    try {
                        onUnavailable()
                    } finally {
                        runCatching { browser?.disconnect() }
                        onFinished()
                    }
                }
            },
            null
        )

        handler.postDelayed(timeoutRunnable, 5000L)

        try {
            browser.connect()
        } catch (_: Exception) {
            handler.removeCallbacks(timeoutRunnable)
            if (!completed) {
                completed = true
                try {
                    onUnavailable()
                } finally {
                    runCatching { browser.disconnect() }
                    onFinished()
                }
            }
        }
    }

    private fun MediaDescriptionCompat?.resolveTitle(metadata: MediaMetadataCompat?): String {
        val descriptionTitle = this?.title?.toString()?.trim().orEmpty()
        if (descriptionTitle.isNotEmpty()) {
            return descriptionTitle
        }

        val mediaTitle = metadata?.getString(MediaMetadataCompat.METADATA_KEY_TITLE)?.trim().orEmpty()
        if (mediaTitle.isNotEmpty()) {
            return mediaTitle
        }

        return "Nothing playing"
    }

    private fun MediaDescriptionCompat?.resolveSubtitle(metadata: MediaMetadataCompat?): String? {
        val descriptionSubtitle = this?.subtitle?.toString()?.trim().orEmpty()
        if (descriptionSubtitle.isNotEmpty()) {
            return descriptionSubtitle
        }

        val artist = metadata?.getString(MediaMetadataCompat.METADATA_KEY_ARTIST)?.trim().orEmpty()
        return artist.ifEmpty { null }
    }

    private val PlaybackStateCompat?.isPlaying: Boolean
        get() {
            return when (this?.state) {
                PlaybackStateCompat.STATE_PLAYING,
                PlaybackStateCompat.STATE_BUFFERING,
                PlaybackStateCompat.STATE_CONNECTING -> true

                else -> false
            }
        }
}
