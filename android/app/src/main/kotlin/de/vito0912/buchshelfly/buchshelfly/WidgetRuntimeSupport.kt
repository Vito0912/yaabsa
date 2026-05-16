package de.vito0912.yaabsa

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.pm.PackageManager

object WidgetRuntimeSupport {
    private const val FALLBACK_AUTOMOTIVE_FEATURE = "android.hardware.type.automotive"

    fun isWidgetSupportEnabled(context: Context): Boolean {
        val appContext = context.applicationContext
        val packageManager = appContext.packageManager

        val isAutomotive = runCatching {
            packageManager.hasSystemFeature(PackageManager.FEATURE_AUTOMOTIVE)
        }.getOrElse {
            packageManager.hasSystemFeature(FALLBACK_AUTOMOTIVE_FEATURE)
        }

        if (isAutomotive) {
            return false
        }

        return appContext.getSystemService(AppWidgetManager::class.java) != null
    }

    fun appWidgetManagerOrNull(context: Context): AppWidgetManager? {
        if (!isWidgetSupportEnabled(context)) {
            return null
        }

        return context.applicationContext.getSystemService(AppWidgetManager::class.java)
    }
}