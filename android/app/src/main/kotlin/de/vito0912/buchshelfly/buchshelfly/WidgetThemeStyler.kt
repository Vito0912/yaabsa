package de.vito0912.yaabsa

import android.content.Context
import android.graphics.Color
import android.widget.RemoteViews

object WidgetThemeStyler {
    private data class Palette(
        val surface: Int,
        val primaryText: Int,
        val secondaryText: Int,
        val iconTint: Int
    )

    private val lightPalette = Palette(
        surface = Color.parseColor("#FFFFFFFF"),
        primaryText = Color.parseColor("#FF111111"),
        secondaryText = Color.parseColor("#FF5A5A5A"),
        iconTint = Color.parseColor("#FF1A1A1A")
    )

    private val darkPalette = Palette(
        surface = Color.parseColor("#FF1F2329"),
        primaryText = Color.parseColor("#FFF2F3F5"),
        secondaryText = Color.parseColor("#FFB9C0CA"),
        iconTint = Color.parseColor("#FFE4E8EE")
    )

    fun applyPlayer(context: Context, views: RemoteViews) {
        val palette = palette(context)
        val isDark = WidgetStorage.isDarkModeEnabled(context)
        views.setInt(R.id.widget_player_root, "setBackgroundResource", if (isDark) R.drawable.widget_background_dark else R.drawable.widget_background_light)
        views.setTextColor(R.id.widget_player_title, palette.primaryText)
        views.setTextColor(R.id.widget_player_subtitle, palette.secondaryText)

        val iconButtons = intArrayOf(
            R.id.widget_player_previous,
            R.id.widget_player_rewind,
            R.id.widget_player_toggle,
            R.id.widget_player_fast_forward,
            R.id.widget_player_next
        )

        for (id in iconButtons) {
            views.setInt(id, "setColorFilter", palette.iconTint)
        }
    }

    fun applyQuickPlay(context: Context, views: RemoteViews) {
        val palette = palette(context)
        views.setInt(R.id.widget_quick_play_root, "setBackgroundColor", palette.surface)
        views.setTextColor(R.id.widget_quick_play_title_text, palette.primaryText)
        views.setTextColor(R.id.widget_quick_play_subtitle_text, palette.secondaryText)
        views.setInt(R.id.widget_quick_play_button, "setColorFilter", palette.iconTint)
    }

    fun applyShelf(context: Context, views: RemoteViews) {
        val palette = palette(context)
        views.setInt(R.id.widget_shelf_root, "setBackgroundColor", palette.surface)
        views.setTextColor(R.id.widget_shelf_title, palette.primaryText)
        views.setTextColor(R.id.widget_shelf_subtitle, palette.secondaryText)
        views.setTextColor(R.id.widget_shelf_item_1, palette.primaryText)
        views.setTextColor(R.id.widget_shelf_item_2, palette.primaryText)
        views.setTextColor(R.id.widget_shelf_item_3, palette.primaryText)
        views.setTextColor(R.id.widget_shelf_item_4, palette.primaryText)
        views.setTextColor(R.id.widget_shelf_item_5, palette.primaryText)
        views.setTextColor(R.id.widget_shelf_item_6, palette.primaryText)
        views.setTextColor(R.id.widget_shelf_item_7, palette.primaryText)
        views.setTextColor(R.id.widget_shelf_item_8, palette.primaryText)
        views.setTextColor(R.id.widget_shelf_item_9, palette.primaryText)
        views.setTextColor(R.id.widget_shelf_item_10, palette.primaryText)
        views.setTextColor(R.id.widget_shelf_item_11, palette.primaryText)
        views.setTextColor(R.id.widget_shelf_item_12, palette.primaryText)
        views.setInt(R.id.widget_shelf_config, "setColorFilter", palette.iconTint)
    }

    private fun palette(context: Context): Palette {
        return if (WidgetStorage.isDarkModeEnabled(context)) {
            darkPalette
        } else {
            lightPalette
        }
    }
}
