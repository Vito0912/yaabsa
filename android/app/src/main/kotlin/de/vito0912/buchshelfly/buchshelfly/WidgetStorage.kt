package de.vito0912.yaabsa

import android.content.Context
import android.content.res.Configuration
import android.graphics.Bitmap
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import java.io.File
import java.io.FileOutputStream

object WidgetStorage {
    private const val PREFS_NAME = "widget_bridge_preferences"
    private const val KEY_SHELF_PREFIX = "shelf_snapshot:"
    private const val KEY_WIDGET_CONFIG_PREFIX = "widget_config:"
    private const val KEY_WIDGET_THEME_DARK = "widget_theme_dark"
    private const val KEY_QUICK_PLAY_STATE = "quick_play_state"
    private const val KEY_POPULATE_ALL_REQUEST = "populate_all_request"
    private const val CONTINUE_LISTENING_SHELF_ID = "continue-listening"

    data class ShelfItem(
        val id: String,
        val title: String,
        val subtitle: String?,
        val author: String?,
        val mediaId: String?,
        val coverUrl: String?,
        val coverAuthToken: String?
    )

    data class ShelfSnapshot(
        val userId: String?,
        val userName: String?,
        val libraryId: String,
        val libraryName: String?,
        val shelfId: String,
        val shelfLabel: String?,
        val items: List<ShelfItem>
    )

    data class ShelfConfig(
        val userId: String?,
        val libraryId: String,
        val shelfId: String
    )

    data class ShelfReference(
        val userId: String?,
        val userName: String?,
        val libraryId: String,
        val libraryName: String?,
        val shelfId: String,
        val shelfLabel: String?
    )

    data class QuickPlayState(
        val title: String,
        val subtitle: String?,
        val coverUrl: String?,
        val coverAuthToken: String?,
        val artworkPath: String?
    )

    private fun prefs(context: Context) =
        context.applicationContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    fun saveShelfSnapshot(
        context: Context,
        userId: String?,
        userName: String?,
        libraryId: String,
        libraryName: String?,
        shelfId: String,
        itemsJson: String,
        shelfLabel: String?
    ) {
        val parsedItems = try {
            JSONArray(itemsJson)
        } catch (_: JSONException) {
            JSONArray()
        }

        val payload = JSONObject().apply {
            if (!userId.isNullOrBlank()) {
                put("userId", userId)
            }
            if (!userName.isNullOrBlank()) {
                put("userName", userName)
            }
            put("libraryId", libraryId)
            if (!libraryName.isNullOrBlank()) {
                put("libraryName", libraryName)
            }
            put("shelfId", shelfId)
            if (!shelfLabel.isNullOrBlank()) {
                put("shelfLabel", shelfLabel)
            }
            put("items", parsedItems)
        }

        prefs(context)
            .edit()
            .putString(shelfStorageKey(userId, libraryId, shelfId), payload.toString())
            .apply()

        if (shelfId == CONTINUE_LISTENING_SHELF_ID) {
            saveQuickPlayStateFromSnapshotItems(context, parsedItems)
        }
    }

    fun clearShelfSnapshots(context: Context) {
        val preferences = prefs(context)
        val editor = preferences.edit()

        for (key in preferences.all.keys) {
            if (key.startsWith(KEY_SHELF_PREFIX)) {
                editor.remove(key)
            }
        }

        editor.remove(KEY_QUICK_PLAY_STATE)
        editor.apply()
    }

    fun requestPopulateAll(context: Context) {
        prefs(context)
            .edit()
            .putBoolean(KEY_POPULATE_ALL_REQUEST, true)
            .apply()
    }

    fun consumePopulateAllRequest(context: Context): Boolean {
        val preferences = prefs(context)
        val shouldPopulate = preferences.getBoolean(KEY_POPULATE_ALL_REQUEST, false)
        if (shouldPopulate) {
            preferences.edit().remove(KEY_POPULATE_ALL_REQUEST).apply()
        }
        return shouldPopulate
    }

    fun saveWidgetConfig(context: Context, appWidgetId: Int, configJson: String): Boolean {
        val config = parseShelfConfig(configJson) ?: return false
        return saveWidgetConfig(context, appWidgetId, config)
    }

    fun saveWidgetConfig(context: Context, appWidgetId: Int, configMap: Map<*, *>): Boolean {
        val payload = JSONObject()
        for ((key, value) in configMap) {
            if (key !is String || value == null) {
                continue
            }
            payload.put(key, value)
        }

        val config = parseShelfConfig(payload.toString()) ?: return false
        return saveWidgetConfig(context, appWidgetId, config)
    }

    fun saveWidgetConfig(context: Context, appWidgetId: Int, config: ShelfConfig): Boolean {
        val payload = JSONObject().apply {
            if (!config.userId.isNullOrBlank()) {
                put("userId", config.userId)
            }
            put("libraryId", config.libraryId)
            put("shelfId", config.shelfId)
        }

        prefs(context)
            .edit()
            .putString(widgetConfigKey(appWidgetId), payload.toString())
            .apply()

        return true
    }

    fun setDarkModeEnabled(context: Context, isDarkMode: Boolean) {
        prefs(context)
            .edit()
            .putBoolean(KEY_WIDGET_THEME_DARK, isDarkMode)
            .apply()
    }

    fun isDarkModeEnabled(context: Context): Boolean {
        val preferences = prefs(context)
        if (preferences.contains(KEY_WIDGET_THEME_DARK)) {
            return preferences.getBoolean(KEY_WIDGET_THEME_DARK, true)
        }

        return true
    }

    fun readWidgetConfig(context: Context, appWidgetId: Int): ShelfConfig? {
        val raw = prefs(context).getString(widgetConfigKey(appWidgetId), null) ?: return null
        return parseShelfConfig(raw)
    }

    fun clearWidgetConfig(context: Context, appWidgetId: Int) {
        prefs(context)
            .edit()
            .remove(widgetConfigKey(appWidgetId))
            .apply()
    }

    fun readShelfSnapshot(context: Context, config: ShelfConfig): ShelfSnapshot? {
        val preferences = prefs(context)

        val direct = preferences.getString(shelfStorageKey(config.userId, config.libraryId, config.shelfId), null)
        if (!direct.isNullOrBlank()) {
            return parseShelfSnapshot(direct)
        }

        val legacy = preferences.getString(legacyShelfStorageKey(config.libraryId, config.shelfId), null)
        if (!legacy.isNullOrBlank()) {
            return parseShelfSnapshot(legacy)
        }

        var userAgnosticMatch: ShelfSnapshot? = null
        for ((key, rawValue) in preferences.all) {
            if (!key.startsWith(KEY_SHELF_PREFIX) || rawValue !is String) {
                continue
            }

            val snapshot = parseShelfSnapshot(rawValue) ?: continue
            if (snapshot.libraryId == config.libraryId && snapshot.shelfId == config.shelfId) {
                if (config.userId.isNullOrBlank() || snapshot.userId == config.userId) {
                    return snapshot
                }

                if (userAgnosticMatch == null) {
                    userAgnosticMatch = snapshot
                }
            }
        }

        return userAgnosticMatch
    }

    fun findShelfReference(context: Context, config: ShelfConfig): ShelfReference? {
        val references = listShelfReferences(context)
        var fallbackReference: ShelfReference? = null

        for (reference in references) {
            if (reference.libraryId != config.libraryId || reference.shelfId != config.shelfId) {
                continue
            }

            if (config.userId.isNullOrBlank() || reference.userId == config.userId) {
                return reference
            }

            if (fallbackReference == null) {
                fallbackReference = reference
            }
        }

        return fallbackReference
    }

    fun listShelfReferences(context: Context): List<ShelfReference> {
        val refs = mutableListOf<ShelfReference>()
        for ((key, rawValue) in prefs(context).all) {
            if (!key.startsWith(KEY_SHELF_PREFIX) || rawValue !is String) {
                continue
            }

            val snapshot = parseShelfSnapshot(rawValue) ?: continue
            refs += ShelfReference(
                userId = snapshot.userId,
                userName = snapshot.userName,
                libraryId = snapshot.libraryId,
                libraryName = snapshot.libraryName,
                shelfId = snapshot.shelfId,
                shelfLabel = snapshot.shelfLabel
            )
        }

        return refs.sortedBy { ref ->
            buildString {
                val userLabel = ref.userName?.trim().orEmpty()
                if (userLabel.isNotEmpty()) {
                    append(userLabel)
                    append("/")
                }

                val libraryLabel = ref.libraryName?.trim().orEmpty()
                if (libraryLabel.isNotEmpty()) {
                    append(libraryLabel)
                } else {
                    append(ref.libraryId)
                }

                append("/")
                append(ref.shelfLabel?.trim().takeUnless { it.isNullOrEmpty() } ?: ref.shelfId)
            }
        }
    }

    fun readQuickPlayState(context: Context): QuickPlayState? {
        val raw = prefs(context).getString(KEY_QUICK_PLAY_STATE, null) ?: return null

        return try {
            val json = JSONObject(raw)
            val title = json.optString("title").trim()
            if (title.isEmpty()) {
                null
            } else {
                val subtitle = json.optString("subtitle").trim().takeIf { it.isNotEmpty() }
                val coverUrl = json.optString("coverUrl").trim().takeIf { it.isNotEmpty() }
                val coverAuthToken = json.optString("coverAuthToken").trim().takeIf { it.isNotEmpty() }
                val artworkPath = json.optString("artworkPath").trim().takeIf { it.isNotEmpty() }
                QuickPlayState(
                    title = title,
                    subtitle = subtitle,
                    coverUrl = coverUrl,
                    coverAuthToken = coverAuthToken,
                    artworkPath = artworkPath
                )
            }
        } catch (_: JSONException) {
            null
        }
    }

    fun saveQuickPlayState(
        context: Context,
        title: String,
        subtitle: String?,
        coverUrl: String? = null,
        coverAuthToken: String? = null,
        artworkPath: String? = null,
        artwork: Bitmap? = null
    ) {
        val normalizedTitle = title.trim()
        if (normalizedTitle.isEmpty() || normalizedTitle == "Nothing playing" || normalizedTitle == "Loading player..." || normalizedTitle == "Open app to start playback") {
            return
        }

        val normalizedSubtitle = subtitle
            ?.trim()
            .takeUnless { it.isNullOrEmpty() }
        val normalizedCoverUrl = coverUrl
            ?.trim()
            .takeUnless { it.isNullOrEmpty() }
        val normalizedCoverAuthToken = coverAuthToken
            ?.trim()
            .takeUnless { it.isNullOrEmpty() }

        val existing = readQuickPlayState(context)
        val titleMatches = existing?.title == normalizedTitle

        var finalArtworkPath = artworkPath?.trim()?.takeIf { it.isNotEmpty() }
        if (artwork != null) {
            val cacheDir = context.applicationContext.cacheDir
            val artworkFile = File(cacheDir, "quick_play_artwork.png")
            try {
                FileOutputStream(artworkFile).use { out ->
                    artwork.compress(Bitmap.CompressFormat.PNG, 100, out)
                }
                finalArtworkPath = artworkFile.absolutePath
            } catch (_: Exception) {
            }
        }

        val finalCoverUrl = normalizedCoverUrl
            ?: if (titleMatches) existing?.coverUrl else null
        val finalCoverAuthToken = normalizedCoverAuthToken
            ?: if (titleMatches) existing?.coverAuthToken else null
        val finalArtworkPathResolved = finalArtworkPath
            ?: if (titleMatches) existing?.artworkPath else null

        val payload = JSONObject().apply {
            put("title", normalizedTitle)
            if (!normalizedSubtitle.isNullOrBlank()) {
                put("subtitle", normalizedSubtitle)
            }
            if (!finalCoverUrl.isNullOrBlank()) {
                put("coverUrl", finalCoverUrl)
            }
            if (!finalCoverAuthToken.isNullOrBlank()) {
                put("coverAuthToken", finalCoverAuthToken)
            }
            if (!finalArtworkPathResolved.isNullOrBlank()) {
                put("artworkPath", finalArtworkPathResolved)
            }
            put("updatedAt", System.currentTimeMillis())
        }

        prefs(context)
            .edit()
            .putString(KEY_QUICK_PLAY_STATE, payload.toString())
            .apply()
    }

    private fun parseShelfConfig(configJson: String): ShelfConfig? {
        return try {
            val json = JSONObject(configJson)
            val userId = json.optString("userId").trim().ifEmpty { null }
            val libraryId = json.optString("libraryId").trim()
            val shelfId = json.optString("shelfId").trim()

            if (libraryId.isEmpty() || shelfId.isEmpty()) {
                null
            } else {
                ShelfConfig(userId = userId, libraryId = libraryId, shelfId = shelfId)
            }
        } catch (_: JSONException) {
            null
        }
    }

    private fun parseShelfSnapshot(raw: String): ShelfSnapshot? {
        return try {
            val json = JSONObject(raw)
            val userId = json.optString("userId").trim().ifEmpty { null }
            val userName = json.optString("userName").trim().ifEmpty { null }
            val libraryId = json.optString("libraryId").trim()
            val libraryName = json.optString("libraryName").trim().ifEmpty { null }
            val shelfId = json.optString("shelfId").trim()
            if (libraryId.isEmpty() || shelfId.isEmpty()) {
                return null
            }

            val shelfLabel = json.optString("shelfLabel").takeIf { it.isNotBlank() }
            val rawItems = json.optJSONArray("items") ?: JSONArray()

            val items = mutableListOf<ShelfItem>()
            for (index in 0 until rawItems.length()) {
                val itemJson = rawItems.optJSONObject(index) ?: continue
                val itemId = itemJson.optString("id").trim()
                if (itemId.isEmpty()) {
                    continue
                }

                val title = itemJson.optString("title").trim().ifEmpty { "Untitled" }
                val subtitle = itemJson.optString("subtitle").trim().takeIf { it.isNotEmpty() }
                val author = itemJson.optString("author").trim().takeIf { it.isNotEmpty() }
                val mediaId = itemJson.optString("mediaId").trim().takeIf { it.isNotEmpty() }
                val coverUrl = itemJson.optString("coverUrl").trim().takeIf { it.isNotEmpty() }
                val coverAuthToken = itemJson.optString("coverAuthToken").trim().takeIf { it.isNotEmpty() }

                items += ShelfItem(
                    id = itemId,
                    title = title,
                    subtitle = subtitle,
                    author = author,
                    mediaId = mediaId,
                    coverUrl = coverUrl,
                    coverAuthToken = coverAuthToken
                )
            }

            ShelfSnapshot(
                userId = userId,
                userName = userName,
                libraryId = libraryId,
                libraryName = libraryName,
                shelfId = shelfId,
                shelfLabel = shelfLabel,
                items = items
            )
        } catch (_: JSONException) {
            null
        }
    }

    private fun shelfStorageKey(userId: String?, libraryId: String, shelfId: String): String {
        val normalizedUserId = userId?.trim().takeUnless { it.isNullOrEmpty() } ?: "_"
        return "$KEY_SHELF_PREFIX${normalizedUserId}::${libraryId}::${shelfId}"
    }

    private fun legacyShelfStorageKey(libraryId: String, shelfId: String): String {
        return "$KEY_SHELF_PREFIX${libraryId}::${shelfId}"
    }

    private fun widgetConfigKey(appWidgetId: Int): String {
        return "$KEY_WIDGET_CONFIG_PREFIX$appWidgetId"
    }

    private fun isSystemInDarkMode(context: Context): Boolean {
        val nightModeMask = context.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK
        return nightModeMask == Configuration.UI_MODE_NIGHT_YES
    }

    private const val KEY_PLAYBACK_LOADING_TIMESTAMP = "playback_loading_timestamp"

    fun setPlaybackLoading(context: Context, loading: Boolean) {
        prefs(context)
            .edit()
            .putLong(KEY_PLAYBACK_LOADING_TIMESTAMP, if (loading) System.currentTimeMillis() else 0L)
            .apply()
    }

    fun isPlaybackLoading(context: Context): Boolean {
        val timestamp = prefs(context).getLong(KEY_PLAYBACK_LOADING_TIMESTAMP, 0L)
        if (timestamp == 0L) {
            return false
        }
        val elapsed = System.currentTimeMillis() - timestamp
        if (elapsed > 8000L) {
            setPlaybackLoading(context, false)
            return false
        }
        return true
    }

    private fun saveQuickPlayStateFromSnapshotItems(context: Context, items: JSONArray) {
        val first = items.optJSONObject(0) ?: return

        val title = first.optString("title").trim()
        if (title.isEmpty()) {
            return
        }

        val subtitle = first.optString("author").trim().ifEmpty {
            first.optString("subtitle").trim()
        }.ifEmpty {
            ""
        }.takeIf { it.isNotEmpty() }
        val coverUrl = first.optString("coverUrl").trim().takeIf { it.isNotEmpty() }
        val coverAuthToken = first.optString("coverAuthToken").trim().takeIf { it.isNotEmpty() }

        saveQuickPlayState(
            context = context,
            title = title,
            subtitle = subtitle,
            coverUrl = coverUrl,
            coverAuthToken = coverAuthToken
        )
    }
}
