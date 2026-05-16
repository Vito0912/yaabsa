package de.vito0912.yaabsa

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context

object WidgetUpdateDispatcher {
    fun updateAll(context: Context) {
        if (!WidgetRuntimeSupport.isWidgetSupportEnabled(context)) {
            return
        }

        updatePlayerWidgets(context)
        updateQuickPlayWidgets(context)
        updateShelfWidgets(context)
    }

    fun updatePlayerWidgets(context: Context) {
        val manager = WidgetRuntimeSupport.appWidgetManagerOrNull(context) ?: return
        val component = ComponentName(context, PlayerControlWidgetProvider::class.java)
        val ids = manager.getAppWidgetIds(component)
        if (ids.isEmpty()) {
            return
        }

        WidgetMediaSessionObserver.ensureConnected(context)
        PlayerControlWidgetProvider.updateWidgets(context, manager, ids)
    }

    fun updateQuickPlayWidgets(context: Context) {
        val manager = WidgetRuntimeSupport.appWidgetManagerOrNull(context) ?: return
        val component = ComponentName(context, QuickPlayWidgetProvider::class.java)
        val ids = manager.getAppWidgetIds(component)
        if (ids.isEmpty()) {
            return
        }

        QuickPlayWidgetProvider.updateWidgets(context, manager, ids)
    }

    fun updateShelfWidgets(context: Context) {
        val manager = WidgetRuntimeSupport.appWidgetManagerOrNull(context) ?: return
        val component = ComponentName(context, ShelfCardWidgetProvider::class.java)
        val ids = manager.getAppWidgetIds(component)
        if (ids.isEmpty()) {
            return
        }

        ShelfCardWidgetProvider.updateWidgets(context, manager, ids)
    }

    fun updateSingleWidget(context: Context, appWidgetId: Int) {
        val manager = WidgetRuntimeSupport.appWidgetManagerOrNull(context) ?: return
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
