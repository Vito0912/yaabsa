package de.vito0912.yaabsa

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context

object WidgetUpdateDispatcher {
    fun updateAll(context: Context) {
        updatePlayerWidgets(context)
        updateQuickPlayWidgets(context)
        updateShelfWidgets(context)
    }

    fun updatePlayerWidgets(context: Context) {
        WidgetMediaSessionObserver.ensureConnected(context)
        val manager = AppWidgetManager.getInstance(context)
        val component = ComponentName(context, PlayerControlWidgetProvider::class.java)
        val ids = manager.getAppWidgetIds(component)
        PlayerControlWidgetProvider.updateWidgets(context, manager, ids)
    }

    fun updateQuickPlayWidgets(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        val component = ComponentName(context, QuickPlayWidgetProvider::class.java)
        val ids = manager.getAppWidgetIds(component)
        QuickPlayWidgetProvider.updateWidgets(context, manager, ids)
    }

    fun updateShelfWidgets(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        val component = ComponentName(context, ShelfCardWidgetProvider::class.java)
        val ids = manager.getAppWidgetIds(component)
        ShelfCardWidgetProvider.updateWidgets(context, manager, ids)
    }

    fun updateSingleWidget(context: Context, appWidgetId: Int) {
        val manager = AppWidgetManager.getInstance(context)
        val info = manager.getAppWidgetInfo(appWidgetId) ?: return
        val providerClassName = info.provider.className

        when {
            providerClassName.endsWith(PlayerControlWidgetProvider::class.java.simpleName) -> {
                PlayerControlWidgetProvider.updateWidgets(context, manager, intArrayOf(appWidgetId))
            }

            providerClassName.endsWith(QuickPlayWidgetProvider::class.java.simpleName) -> {
                QuickPlayWidgetProvider.updateWidgets(context, manager, intArrayOf(appWidgetId))
            }

            providerClassName.endsWith(ShelfCardWidgetProvider::class.java.simpleName) -> {
                ShelfCardWidgetProvider.updateWidgets(context, manager, intArrayOf(appWidgetId))
            }
        }
    }
}
