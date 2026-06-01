package de.vito0912.yaabsa

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews

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
            WidgetMediaBridge.performTransportAction(context, action)
            WidgetUpdateDispatcher.updatePlayerWidgets(context)
        }
    }

    companion object {
        private const val HIDE_SKIP_CONTROLS_BELOW_WIDTH_DP = 300

        fun updateWidgets(context: Context, manager: AppWidgetManager, appWidgetIds: IntArray) {
            if (appWidgetIds.isEmpty()) {
                return
            }

            for (appWidgetId in appWidgetIds) {
                val hideSkipControls = isNarrowWidget(manager, appWidgetId)
                val initialViews = baseViews(context, appWidgetId, hideSkipControls)
                initialViews.setTextViewText(R.id.widget_player_title, "Loading player...")
                initialViews.setTextViewText(R.id.widget_player_subtitle, "")
                initialViews.setImageViewResource(R.id.widget_player_artwork, R.drawable.ic_launcher_foreground)
                initialViews.setImageViewResource(R.id.widget_player_toggle, R.drawable.widget_play_arrow)
                WidgetThemeStyler.applyPlayer(context, initialViews)
                manager.updateAppWidget(appWidgetId, initialViews)
            }

            WidgetMediaBridge.requestNowPlaying(context) { state ->
                if (state != null) {
                    WidgetStorage.saveQuickPlayState(context, state.title, state.subtitle)
                    WidgetUpdateDispatcher.updateQuickPlayWidgets(context)
                }

                for (appWidgetId in appWidgetIds) {
                    val hideSkipControls = isNarrowWidget(manager, appWidgetId)
                    val views = baseViews(context, appWidgetId, hideSkipControls)

                    if (state == null) {
                        views.setTextViewText(R.id.widget_player_title, "Open app to start playback")
                        views.setTextViewText(R.id.widget_player_subtitle, "")
                        views.setImageViewResource(R.id.widget_player_artwork, R.drawable.ic_launcher_foreground)
                        views.setImageViewResource(R.id.widget_player_toggle, R.drawable.widget_play_arrow)
                    } else {
                        views.setTextViewText(R.id.widget_player_title, state.title)
                        views.setTextViewText(R.id.widget_player_subtitle, state.subtitle ?: "")
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

                    WidgetThemeStyler.applyPlayer(context, views)

                    manager.updateAppWidget(appWidgetId, views)
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
