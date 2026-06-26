package de.vito0912.yaabsa

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import java.io.File

class QuickPlayWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        updateWidgets(context, appWidgetManager, appWidgetIds)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        if (intent.action == WidgetMediaBridge.ACTION_QUICK_PLAY) {
            WidgetStorage.setPlaybackLoading(context, true)
            WidgetUpdateDispatcher.updatePlayerWidgets(context)
            WidgetUpdateDispatcher.updateQuickPlayWidgets(context)
            WidgetMediaBridge.performTransportAction(context, WidgetMediaBridge.ACTION_QUICK_PLAY)
        }
    }

    companion object {
        fun updateWidgets(context: Context, manager: AppWidgetManager, appWidgetIds: IntArray) {
            if (appWidgetIds.isEmpty()) {
                return
            }

            val persistedQuickPlayState = WidgetStorage.readQuickPlayState(context)
            val initialPlaybackLoading = WidgetStorage.isPlaybackLoading(context)

            for (appWidgetId in appWidgetIds) {
                val views = RemoteViews(context.packageName, R.layout.widget_quick_play)
                views.setTextViewText(
                    R.id.widget_quick_play_title_text,
                    persistedQuickPlayState?.title ?: context.getString(R.string.widget_quick_play_title)
                )
                views.setTextViewText(
                    R.id.widget_quick_play_subtitle_text,
                    if (initialPlaybackLoading) "Loading playback..." else (persistedQuickPlayState?.subtitle ?: context.getString(R.string.widget_quick_play_subtitle_default))
                )
                views.setImageViewResource(R.id.widget_quick_play_cover, R.drawable.ic_launcher_foreground)
                views.setImageViewResource(R.id.widget_quick_play_button, R.drawable.widget_play_arrow)
                views.setViewVisibility(R.id.widget_quick_play_button, if (initialPlaybackLoading) android.view.View.GONE else android.view.View.VISIBLE)
                views.setViewVisibility(R.id.widget_quick_play_progress, if (initialPlaybackLoading) android.view.View.VISIBLE else android.view.View.GONE)

                bindClickActions(context, views, appWidgetId)
                WidgetThemeStyler.applyQuickPlay(context, views)
                manager.updateAppWidget(appWidgetId, views)

                loadPersistedCoverIfAvailable(context, manager, appWidgetId, persistedQuickPlayState)
            }

            WidgetMediaBridge.requestNowPlaying(context) { nowPlayingState ->
                if (nowPlayingState != null && nowPlayingState.isPlaying) {
                    WidgetStorage.setPlaybackLoading(context, false)
                }

                if (nowPlayingState != null) {
                    WidgetStorage.saveQuickPlayState(
                        context = context,
                        title = nowPlayingState.title,
                        subtitle = nowPlayingState.subtitle,
                        artwork = nowPlayingState.artwork
                    )
                }

                val quickPlayState = WidgetStorage.readQuickPlayState(context)
                val isPlaybackLoading = WidgetStorage.isPlaybackLoading(context)
                for (appWidgetId in appWidgetIds) {
                    val refreshedViews = RemoteViews(context.packageName, R.layout.widget_quick_play)
                    refreshedViews.setTextViewText(
                        R.id.widget_quick_play_title_text,
                        nowPlayingState?.title
                            ?: quickPlayState?.title
                            ?: context.getString(R.string.widget_quick_play_title)
                    )
                    refreshedViews.setTextViewText(
                        R.id.widget_quick_play_subtitle_text,
                        if (isPlaybackLoading && (nowPlayingState == null || !nowPlayingState.isPlaying)) {
                            "Loading playback..."
                        } else {
                            nowPlayingState?.subtitle
                                ?: quickPlayState?.subtitle
                                ?: context.getString(R.string.widget_quick_play_subtitle_default)
                        }
                    )
                    refreshedViews.setImageViewResource(R.id.widget_quick_play_button, R.drawable.widget_play_arrow)

                    if (nowPlayingState?.artwork != null) {
                        refreshedViews.setImageViewBitmap(R.id.widget_quick_play_cover, nowPlayingState.artwork)
                    } else {
                        refreshedViews.setImageViewResource(R.id.widget_quick_play_cover, R.drawable.ic_launcher_foreground)
                    }

                    val showLoading = isPlaybackLoading && (nowPlayingState == null || !nowPlayingState.isPlaying)
                    refreshedViews.setViewVisibility(R.id.widget_quick_play_button, if (showLoading) android.view.View.GONE else android.view.View.VISIBLE)
                    refreshedViews.setViewVisibility(R.id.widget_quick_play_progress, if (showLoading) android.view.View.VISIBLE else android.view.View.GONE)

                    bindClickActions(context, refreshedViews, appWidgetId)
                    WidgetThemeStyler.applyQuickPlay(context, refreshedViews)
                    manager.updateAppWidget(appWidgetId, refreshedViews)

                    if (nowPlayingState == null) {
                        loadPersistedCoverIfAvailable(context, manager, appWidgetId, quickPlayState)
                    }
                }
            }
        }

        fun updateAll(context: Context) {
            val manager = WidgetRuntimeSupport.appWidgetManagerOrNull(context) ?: return
            val component = android.content.ComponentName(context, QuickPlayWidgetProvider::class.java)
            val ids = manager.getAppWidgetIds(component)
            updateWidgets(context, manager, ids)
        }

        private fun quickPlayPendingIntent(context: Context, appWidgetId: Int): PendingIntent {
            val intent = Intent(context, QuickPlayWidgetProvider::class.java).apply {
                action = WidgetMediaBridge.ACTION_QUICK_PLAY
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }

            return PendingIntent.getBroadcast(
                context,
                appWidgetId + 97,
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
                appWidgetId + 101,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        }

        private fun bindClickActions(context: Context, views: RemoteViews, appWidgetId: Int) {
            views.setOnClickPendingIntent(
                R.id.widget_quick_play_button,
                quickPlayPendingIntent(context, appWidgetId)
            )
            views.setOnClickPendingIntent(R.id.widget_quick_play_root, appLaunchPendingIntent(context, appWidgetId))
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
                            val partialUpdate = RemoteViews(context.packageName, R.layout.widget_quick_play)
                            partialUpdate.setImageViewBitmap(R.id.widget_quick_play_cover, bitmap)
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
                    val partialUpdate = RemoteViews(context.packageName, R.layout.widget_quick_play)
                    partialUpdate.setImageViewBitmap(R.id.widget_quick_play_cover, bitmap)
                    manager.partiallyUpdateAppWidget(appWidgetId, partialUpdate)
                }
            }
        }
    }
}
