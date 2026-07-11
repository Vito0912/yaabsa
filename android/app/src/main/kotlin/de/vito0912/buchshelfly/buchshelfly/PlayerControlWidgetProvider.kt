package de.vito0912.yaabsa

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.view.View
import android.widget.RemoteViews
import java.io.File

class PlayerControlWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        updateWidgets(context, appWidgetManager, appWidgetIds)
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: android.os.Bundle
    ) {
        updateWidgets(context, appWidgetManager, intArrayOf(appWidgetId))
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        val action = intent.action ?: return
        if (action == WidgetMediaBridge.ACTION_PLAYER_TOGGLE ||
            action == WidgetMediaBridge.ACTION_PLAYER_NEXT ||
            action == WidgetMediaBridge.ACTION_PLAYER_PREVIOUS ||
            action == WidgetMediaBridge.ACTION_PLAYER_REWIND ||
            action == WidgetMediaBridge.ACTION_PLAYER_FAST_FORWARD ||
            action == WidgetMediaBridge.ACTION_PLAYER_STOP
        ) {
            if (action == WidgetMediaBridge.ACTION_PLAYER_TOGGLE) {
                WidgetStorage.setPlaybackLoading(context, true)
                WidgetUpdateDispatcher.updatePlayerWidgets(context)
                WidgetUpdateDispatcher.updateQuickPlayWidgets(context)
            }
            val pendingResult = goAsync()
            try {
                WidgetMediaBridge.performTransportAction(
                    context = context,
                    action = action,
                    onDispatched = { pendingResult.finish() },
                )
            } catch (_: Exception) {
                pendingResult.finish()
            }
        }
    }

    companion object {
        private const val HIDE_SKIP_CONTROLS_BELOW_WIDTH_DP = 300

        fun updateWidgets(context: Context, manager: AppWidgetManager, appWidgetIds: IntArray) {
            if (appWidgetIds.isEmpty()) {
                return
            }

            val persistedQuickPlayState = WidgetStorage.readQuickPlayState(context)
            val initialPlaybackLoading = WidgetStorage.isPlaybackLoading(context)

            for (appWidgetId in appWidgetIds) {
                val hideSkipControls = isNarrowWidget(manager, appWidgetId)
                val initialViews = baseViews(context, appWidgetId, hideSkipControls)

                if (persistedQuickPlayState != null) {
                    initialViews.setTextViewText(R.id.widget_player_title, persistedQuickPlayState.title)
                    initialViews.setTextViewText(
                        R.id.widget_player_subtitle,
                        if (initialPlaybackLoading) "Loading playback..." else (persistedQuickPlayState.subtitle ?: "")
                    )
                } else {
                    initialViews.setTextViewText(
                        R.id.widget_player_title,
                        if (initialPlaybackLoading) "Loading playback..." else "Open app to start playback"
                    )
                    initialViews.setTextViewText(R.id.widget_player_subtitle, "")
                }
                initialViews.setImageViewResource(R.id.widget_player_artwork, R.drawable.ic_launcher_foreground)
                initialViews.setImageViewResource(R.id.widget_player_toggle, R.drawable.widget_play_arrow)
                initialViews.setViewVisibility(R.id.widget_player_toggle, if (initialPlaybackLoading) View.GONE else View.VISIBLE)
                initialViews.setViewVisibility(R.id.widget_player_progress, if (initialPlaybackLoading) View.VISIBLE else View.GONE)

                WidgetThemeStyler.applyPlayer(context, initialViews)
                manager.updateAppWidget(appWidgetId, initialViews)
                loadPersistedCoverIfAvailable(context, manager, appWidgetId, persistedQuickPlayState)
            }

            WidgetMediaBridge.requestNowPlaying(context) { state ->
                if (state != null && state.isPlaying) {
                    WidgetStorage.setPlaybackLoading(context, false)
                }

                if (state != null) {
                    WidgetStorage.saveQuickPlayState(
                        context = context,
                        title = state.title,
                        subtitle = state.subtitle,
                        artwork = state.artwork
                    )
                    WidgetUpdateDispatcher.updateQuickPlayWidgets(context)
                }

                val quickPlayState = WidgetStorage.readQuickPlayState(context)
                val isPlaybackLoading = WidgetStorage.isPlaybackLoading(context)

                for (appWidgetId in appWidgetIds) {
                    val hideSkipControls = isNarrowWidget(manager, appWidgetId)
                    val views = baseViews(context, appWidgetId, hideSkipControls)

                    if (state == null) {
                        if (quickPlayState != null) {
                            views.setTextViewText(R.id.widget_player_title, quickPlayState.title)
                            views.setTextViewText(
                                R.id.widget_player_subtitle,
                                if (isPlaybackLoading) "Loading playback..." else (quickPlayState.subtitle ?: "")
                            )
                            views.setImageViewResource(R.id.widget_player_artwork, R.drawable.ic_launcher_foreground)
                            views.setImageViewResource(R.id.widget_player_toggle, R.drawable.widget_play_arrow)
                        } else {
                            views.setTextViewText(
                                R.id.widget_player_title,
                                if (isPlaybackLoading) "Loading playback..." else "Open app to start playback"
                            )
                            views.setTextViewText(R.id.widget_player_subtitle, "")
                            views.setImageViewResource(R.id.widget_player_artwork, R.drawable.ic_launcher_foreground)
                            views.setImageViewResource(R.id.widget_player_toggle, R.drawable.widget_play_arrow)
                        }
                    } else {
                        views.setTextViewText(R.id.widget_player_title, state.title)
                        views.setTextViewText(
                            R.id.widget_player_subtitle,
                            if (isPlaybackLoading && !state.isPlaying) "Loading playback..." else (state.subtitle ?: "")
                        )
                        if (state.artwork != null) {
                            views.setImageViewBitmap(R.id.widget_player_artwork, state.artwork)
                        } else {
                            views.setImageViewResource(R.id.widget_player_artwork, R.drawable.ic_launcher_foreground)
                        }
                        views.setImageViewResource(
                            R.id.widget_player_toggle,
                            if (state.isPlaying) R.drawable.widget_pause else R.drawable.widget_play_arrow
                        )
                    }

                    val showLoading = isPlaybackLoading && (state == null || !state.isPlaying)
                    views.setViewVisibility(R.id.widget_player_toggle, if (showLoading) View.GONE else View.VISIBLE)
                    views.setViewVisibility(R.id.widget_player_progress, if (showLoading) View.VISIBLE else View.GONE)

                    WidgetThemeStyler.applyPlayer(context, views)
                    manager.updateAppWidget(appWidgetId, views)

                    if (state == null) {
                        loadPersistedCoverIfAvailable(context, manager, appWidgetId, quickPlayState)
                    }
                }
            }
        }

        private fun loadPersistedCoverIfAvailable(
            context: Context,
            manager: AppWidgetManager,
            appWidgetId: Int,
            quickPlayState: WidgetStorage.QuickPlayState?
        ) {
            val artworkPath = quickPlayState?.artworkPath
            if (!artworkPath.isNullOrBlank()) {
                val file = File(artworkPath)
                if (file.exists()) {
                    try {
                        val bitmap = BitmapFactory.decodeFile(artworkPath)
                        if (bitmap != null) {
                            val partialUpdate = RemoteViews(context.packageName, R.layout.widget_player_control)
                            partialUpdate.setImageViewBitmap(R.id.widget_player_artwork, bitmap)
                            manager.partiallyUpdateAppWidget(appWidgetId, partialUpdate)
                            return
                        }
                    } catch (_: Exception) {
                    }
                }
            }

            val coverUrl = quickPlayState?.coverUrl
            if (coverUrl.isNullOrBlank()) {
                return
            }

            WidgetCoverLoader.loadCover(coverUrl, quickPlayState.coverAuthToken) { bitmap ->
                if (bitmap != null) {
                    val partialUpdate = RemoteViews(context.packageName, R.layout.widget_player_control)
                    partialUpdate.setImageViewBitmap(R.id.widget_player_artwork, bitmap)
                    manager.partiallyUpdateAppWidget(appWidgetId, partialUpdate)
                }
            }
        }

        fun updateAll(context: Context) {
            val manager = WidgetRuntimeSupport.appWidgetManagerOrNull(context) ?: return
            val component = android.content.ComponentName(context, PlayerControlWidgetProvider::class.java)
            val ids = manager.getAppWidgetIds(component)
            updateWidgets(context, manager, ids)
        }

        private fun baseViews(context: Context, appWidgetId: Int, hideSkipControls: Boolean): RemoteViews {
            val views = RemoteViews(context.packageName, R.layout.widget_player_control)

            val skipControlsVisibility = if (hideSkipControls) View.GONE else View.VISIBLE
            views.setViewVisibility(R.id.widget_player_previous, skipControlsVisibility)
            views.setViewVisibility(R.id.widget_player_next, skipControlsVisibility)

            views.setOnClickPendingIntent(
                R.id.widget_player_toggle,
                actionPendingIntent(context, appWidgetId, WidgetMediaBridge.ACTION_PLAYER_TOGGLE)
            )
            views.setOnClickPendingIntent(
                R.id.widget_player_previous,
                actionPendingIntent(context, appWidgetId, WidgetMediaBridge.ACTION_PLAYER_PREVIOUS)
            )
            views.setOnClickPendingIntent(
                R.id.widget_player_rewind,
                actionPendingIntent(context, appWidgetId, WidgetMediaBridge.ACTION_PLAYER_REWIND)
            )
            views.setOnClickPendingIntent(
                R.id.widget_player_next,
                actionPendingIntent(context, appWidgetId, WidgetMediaBridge.ACTION_PLAYER_NEXT)
            )
            views.setOnClickPendingIntent(
                R.id.widget_player_fast_forward,
                actionPendingIntent(context, appWidgetId, WidgetMediaBridge.ACTION_PLAYER_FAST_FORWARD)
            )
            views.setOnClickPendingIntent(R.id.widget_player_root, appLaunchPendingIntent(context, appWidgetId))
            return views
        }

        private fun isNarrowWidget(manager: AppWidgetManager, appWidgetId: Int): Boolean {
            val options = manager.getAppWidgetOptions(appWidgetId)
            val minWidthDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0)
            return minWidthDp in 1 until HIDE_SKIP_CONTROLS_BELOW_WIDTH_DP
        }

        private fun actionPendingIntent(context: Context, appWidgetId: Int, action: String): PendingIntent {
            val intent = Intent(context, PlayerControlWidgetProvider::class.java).apply {
                this.action = action
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            return PendingIntent.getBroadcast(
                context,
                appWidgetId + action.hashCode(),
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        }

        private fun appLaunchPendingIntent(context: Context, appWidgetId: Int): PendingIntent {
            val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            } ?: Intent()

            return PendingIntent.getActivity(
                context,
                appWidgetId,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        }
    }
}
