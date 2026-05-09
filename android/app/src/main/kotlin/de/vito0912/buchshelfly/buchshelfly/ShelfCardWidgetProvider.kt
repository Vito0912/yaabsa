package de.vito0912.yaabsa

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews

class ShelfCardWidgetProvider : AppWidgetProvider() {
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

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        super.onDeleted(context, appWidgetIds)
        for (appWidgetId in appWidgetIds) {
            WidgetStorage.clearWidgetConfig(context, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        if (intent.action == WidgetMediaBridge.ACTION_SHELF_ITEM) {
            val mediaId = intent.getStringExtra(WidgetMediaBridge.EXTRA_MEDIA_ID)
            if (!mediaId.isNullOrBlank()) {
                launchAppToForeground(context, mediaId)
                WidgetUpdateDispatcher.updatePlayerWidgets(context)
            }
        }
    }

    private fun launchAppToForeground(context: Context, mediaId: String) {
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName) ?: return
        launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        launchIntent.putExtra(WidgetMediaBridge.EXTRA_WIDGET_MEDIA_ID_TO_PLAY, mediaId)
        runCatching {
            context.startActivity(launchIntent)
        }
    }

    companion object {
        private const val MIN_WIDGET_ITEMS = 1
        private const val MAX_WIDGET_ITEMS = 12
        private const val APPROX_HEADER_HEIGHT_DP = 56
        private const val APPROX_ROW_HEIGHT_DP = 32
        private val itemTextViewIds = intArrayOf(
            R.id.widget_shelf_item_1,
            R.id.widget_shelf_item_2,
            R.id.widget_shelf_item_3,
            R.id.widget_shelf_item_4,
            R.id.widget_shelf_item_5,
            R.id.widget_shelf_item_6,
            R.id.widget_shelf_item_7,
            R.id.widget_shelf_item_8,
            R.id.widget_shelf_item_9,
            R.id.widget_shelf_item_10,
            R.id.widget_shelf_item_11,
            R.id.widget_shelf_item_12
        )
        private val itemRowViewIds = intArrayOf(
            R.id.widget_shelf_item_row_1,
            R.id.widget_shelf_item_row_2,
            R.id.widget_shelf_item_row_3,
            R.id.widget_shelf_item_row_4,
            R.id.widget_shelf_item_row_5,
            R.id.widget_shelf_item_row_6,
            R.id.widget_shelf_item_row_7,
            R.id.widget_shelf_item_row_8,
            R.id.widget_shelf_item_row_9,
            R.id.widget_shelf_item_row_10,
            R.id.widget_shelf_item_row_11,
            R.id.widget_shelf_item_row_12
        )

        fun updateWidgets(context: Context, manager: AppWidgetManager, appWidgetIds: IntArray) {
            for (appWidgetId in appWidgetIds) {
                val views = RemoteViews(context.packageName, R.layout.widget_shelf_card)
                bindStaticActions(context, views, appWidgetId)
                val visibleRows = desiredVisibleRows(manager, appWidgetId)

                val config = WidgetStorage.readWidgetConfig(context, appWidgetId)
                if (config == null) {
                    renderUnconfiguredState(context, views, appWidgetId, visibleRows)
                    WidgetThemeStyler.applyShelf(context, views)
                    manager.updateAppWidget(appWidgetId, views)
                    continue
                }

                val snapshot = WidgetStorage.readShelfSnapshot(context, config)
                if (snapshot == null || snapshot.items.isEmpty()) {
                    renderEmptySnapshotState(context, views, appWidgetId, config, visibleRows)
                    WidgetThemeStyler.applyShelf(context, views)
                    manager.updateAppWidget(appWidgetId, views)
                    continue
                }

                views.setTextViewText(
                    R.id.widget_shelf_title,
                    snapshot.shelfLabel ?: snapshot.libraryName ?: snapshot.libraryId
                )
                views.setViewVisibility(R.id.widget_shelf_subtitle, View.VISIBLE)
                views.setTextViewText(R.id.widget_shelf_subtitle, buildShelfMetadataLine(snapshot))

                for (index in itemTextViewIds.indices) {
                    val itemViewId = itemTextViewIds[index]
                    val rowViewId = itemRowViewIds[index]

                    val rowVisible = index < visibleRows
                    views.setViewVisibility(rowViewId, if (rowVisible) View.VISIBLE else View.GONE)
                    if (!rowVisible) {
                        continue
                    }

                    if (index < snapshot.items.size && index < MAX_WIDGET_ITEMS) {
                        val item = snapshot.items[index]
                        val line = item.title

                        views.setTextViewText(itemViewId, line)

                        if (!item.mediaId.isNullOrBlank()) {
                            val pendingIntent = shelfItemPendingIntent(context, appWidgetId, item.mediaId)
                            views.setOnClickPendingIntent(itemViewId, pendingIntent)
                            views.setOnClickPendingIntent(rowViewId, pendingIntent)
                        } else {
                            val launchIntent = appLaunchPendingIntent(context, appWidgetId)
                            views.setOnClickPendingIntent(itemViewId, launchIntent)
                            views.setOnClickPendingIntent(rowViewId, launchIntent)
                        }
                    } else {
                        views.setTextViewText(itemViewId, "")
                        val launchIntent = appLaunchPendingIntent(context, appWidgetId)
                        views.setOnClickPendingIntent(itemViewId, launchIntent)
                        views.setOnClickPendingIntent(rowViewId, launchIntent)
                    }
                }

                WidgetThemeStyler.applyShelf(context, views)
                manager.updateAppWidget(appWidgetId, views)
            }
        }

        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val component = android.content.ComponentName(context, ShelfCardWidgetProvider::class.java)
            val ids = manager.getAppWidgetIds(component)
            updateWidgets(context, manager, ids)
        }

        private fun bindStaticActions(context: Context, views: RemoteViews, appWidgetId: Int) {
            views.setOnClickPendingIntent(R.id.widget_shelf_config, openConfigPendingIntent(context, appWidgetId))
            views.setOnClickPendingIntent(R.id.widget_shelf_root, appLaunchPendingIntent(context, appWidgetId))
        }

        private fun renderUnconfiguredState(context: Context, views: RemoteViews, appWidgetId: Int, visibleRows: Int) {
            views.setTextViewText(R.id.widget_shelf_title, "Shelf widget")
            views.setViewVisibility(R.id.widget_shelf_subtitle, View.VISIBLE)
            views.setTextViewText(R.id.widget_shelf_subtitle, "Tap pencil to choose a shelf snapshot")

            for (index in itemTextViewIds.indices) {
                val textViewId = itemTextViewIds[index]
                val rowViewId = itemRowViewIds[index]
                val rowVisible = index < visibleRows

                views.setViewVisibility(rowViewId, if (rowVisible) View.VISIBLE else View.GONE)
                if (!rowVisible) {
                    continue
                }

                views.setTextViewText(textViewId, "")
                val openConfigIntent = openConfigPendingIntent(context, appWidgetId)
                views.setOnClickPendingIntent(textViewId, openConfigIntent)
                views.setOnClickPendingIntent(rowViewId, openConfigIntent)
            }

            views.setOnClickPendingIntent(R.id.widget_shelf_root, openConfigPendingIntent(context, appWidgetId))
        }

        private fun renderEmptySnapshotState(
            context: Context,
            views: RemoteViews,
            appWidgetId: Int,
            config: WidgetStorage.ShelfConfig,
            visibleRows: Int
        ) {
            val matchingReference = WidgetStorage.findShelfReference(context, config)
            val shelfTitle = matchingReference
                ?.shelfLabel
                ?.trim()
                .takeUnless { it.isNullOrEmpty() }
                ?: context.getString(R.string.widget_shelf_title_default)
            val libraryLabel = matchingReference
                ?.libraryName
                ?.trim()
                .takeUnless { it.isNullOrEmpty() }
                ?: context.getString(R.string.widget_shelf_name)

            views.setTextViewText(R.id.widget_shelf_title, shelfTitle)
            views.setViewVisibility(R.id.widget_shelf_subtitle, View.VISIBLE)
            views.setTextViewText(
                R.id.widget_shelf_subtitle,
                "$libraryLabel • No snapshot items yet. Tap Populate all in configuration."
            )

            for (index in itemTextViewIds.indices) {
                val textViewId = itemTextViewIds[index]
                val rowViewId = itemRowViewIds[index]
                val rowVisible = index < visibleRows

                views.setViewVisibility(rowViewId, if (rowVisible) View.VISIBLE else View.GONE)
                if (!rowVisible) {
                    continue
                }

                views.setTextViewText(textViewId, "")
                val launchIntent = appLaunchPendingIntent(context, appWidgetId)
                views.setOnClickPendingIntent(textViewId, launchIntent)
                views.setOnClickPendingIntent(rowViewId, launchIntent)
            }
        }

        private fun buildShelfMetadataLine(snapshot: WidgetStorage.ShelfSnapshot): String {
            val libraryLabel = snapshot.libraryName?.trim().takeUnless { it.isNullOrEmpty() } ?: snapshot.libraryId
            val userLabel = snapshot.userName?.trim().takeUnless { it.isNullOrEmpty() } ?: snapshot.userId

            return if (!userLabel.isNullOrBlank()) {
                "$libraryLabel • $userLabel"
            } else {
                libraryLabel
            }
        }

        private fun desiredVisibleRows(manager: AppWidgetManager, appWidgetId: Int): Int {
            val options = manager.getAppWidgetOptions(appWidgetId)
            val minHeightDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 0)
            val maxHeightDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT, 0)
            val effectiveHeightDp = when {
                maxHeightDp > 0 && minHeightDp > 0 -> maxOf(maxHeightDp, minHeightDp)
                maxHeightDp > 0 -> maxHeightDp
                else -> minHeightDp
            }

            if (effectiveHeightDp <= 0) {
                return MIN_WIDGET_ITEMS
            }

            val availableHeightDp = (effectiveHeightDp - APPROX_HEADER_HEIGHT_DP).coerceAtLeast(APPROX_ROW_HEIGHT_DP)
            val estimatedRows = availableHeightDp / APPROX_ROW_HEIGHT_DP

            return estimatedRows.coerceIn(MIN_WIDGET_ITEMS, MAX_WIDGET_ITEMS)
        }

        private fun shelfItemPendingIntent(context: Context, appWidgetId: Int, mediaId: String): PendingIntent {
            val intent = Intent(context, ShelfCardWidgetProvider::class.java).apply {
                action = WidgetMediaBridge.ACTION_SHELF_ITEM
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                putExtra(WidgetMediaBridge.EXTRA_MEDIA_ID, mediaId)
            }

            return PendingIntent.getBroadcast(
                context,
                appWidgetId + mediaId.hashCode(),
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        }

        private fun openConfigPendingIntent(context: Context, appWidgetId: Int): PendingIntent {
            val intent = Intent(context, WidgetConfigActivity::class.java).apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }

            return PendingIntent.getActivity(
                context,
                appWidgetId + 211,
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
                appWidgetId + 221,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        }
    }
}
