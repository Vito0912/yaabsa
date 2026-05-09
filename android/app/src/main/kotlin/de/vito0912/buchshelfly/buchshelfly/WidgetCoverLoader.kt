package de.vito0912.yaabsa

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Handler
import android.os.Looper
import android.util.LruCache
import java.io.BufferedInputStream
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.Executors

object WidgetCoverLoader {
    private val executor = Executors.newFixedThreadPool(2)
    private val mainHandler = Handler(Looper.getMainLooper())

    private val bitmapCache = object : LruCache<String, Bitmap>(4 * 1024 * 1024) {
        override fun sizeOf(key: String, value: Bitmap): Int = value.byteCount
    }

    fun loadCover(
        coverUrl: String,
        coverAuthToken: String?,
        onLoaded: (Bitmap?) -> Unit
    ) {
        val normalizedUrl = coverUrl.trim()
        if (normalizedUrl.isEmpty()) {
            onLoaded(null)
            return
        }

        val cacheKey = buildCacheKey(normalizedUrl, coverAuthToken)
        val cachedBitmap = bitmapCache.get(cacheKey)
        if (cachedBitmap != null) {
            onLoaded(cachedBitmap)
            return
        }

        executor.execute {
            val loadedBitmap = runCatching {
                fetchBitmap(normalizedUrl, coverAuthToken)
            }.getOrNull()

            if (loadedBitmap != null) {
                bitmapCache.put(cacheKey, loadedBitmap)
            }

            mainHandler.post {
                onLoaded(loadedBitmap)
            }
        }
    }

    private fun buildCacheKey(url: String, authToken: String?): String {
        val authPart = authToken?.trim().takeUnless { it.isNullOrEmpty() } ?: "_"
        return "$url::$authPart"
    }

    private fun fetchBitmap(url: String, authToken: String?): Bitmap? {
        val connection = (URL(url).openConnection() as? HttpURLConnection) ?: return null
        connection.connectTimeout = 2500
        connection.readTimeout = 2500
        connection.instanceFollowRedirects = true

        val authorizationHeader = authToken
            ?.trim()
            .takeUnless { it.isNullOrEmpty() }
            ?.let { token ->
                if (token.startsWith("Bearer ", ignoreCase = true)) {
                    token
                } else {
                    "Bearer $token"
                }
            }

        if (!authorizationHeader.isNullOrBlank()) {
            connection.setRequestProperty("Authorization", authorizationHeader)
        }

        return try {
            connection.connect()
            if (connection.responseCode !in 200..299) {
                null
            } else {
                BufferedInputStream(connection.inputStream).use { stream ->
                    BitmapFactory.decodeStream(stream)
                }
            }
        } finally {
            connection.disconnect()
        }
    }
}
