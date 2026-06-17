package de.vito0912.yaabsa

import android.content.ContentProvider
import android.content.ContentValues
import android.database.Cursor
import android.net.Uri
import android.os.ParcelFileDescriptor
import android.util.Base64
import android.util.Log
import java.io.File
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.net.HttpURLConnection
import java.net.URL
import java.security.MessageDigest
import java.util.concurrent.ConcurrentHashMap

class CoversContentProvider : ContentProvider() {
    companion object {
        private const val TAG = "CoversContentProvider"
    }

    private val locks = ConcurrentHashMap<String, Any>()

    override fun onCreate(): Boolean {
        return true
    }

    @Throws(FileNotFoundException::class)
    override fun openFile(uri: Uri, mode: String): ParcelFileDescriptor? {
        val lastSegment = uri.lastPathSegment ?: throw FileNotFoundException("No URI path segment")
        val source = try {
            val decodedBytes = Base64.decode(lastSegment, Base64.URL_SAFE or Base64.NO_PADDING)
            String(decodedBytes, Charsets.UTF_8)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to decode base64 segment: $lastSegment", e)
            throw FileNotFoundException("Invalid encoded URI: ${e.message}")
        }

        if (source.isEmpty()) {
            throw FileNotFoundException("Decoded source URI is empty")
        }

        Log.d(TAG, "Resolving cover for source: $source")

        if (source.startsWith("file://") || source.startsWith("/")) {
            val filePath = if (source.startsWith("file://")) {
                Uri.parse(source).path ?: throw FileNotFoundException("Invalid file URI path")
            } else {
                source
            }
            val file = File(filePath)
            if (!file.exists()) {
                Log.w(TAG, "File does not exist: $filePath")
                throw FileNotFoundException("File not found: $filePath")
            }
            return ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY)
        } else if (source.startsWith("http://") || source.startsWith("https://")) {
            val cacheDir = File(context?.cacheDir, "covers")
            if (!cacheDir.exists()) {
                cacheDir.mkdirs()
            }
            val hashedName = md5(source)
            val cacheFile = File(cacheDir, hashedName)

            if (!cacheFile.exists()) {
                val lock = locks.computeIfAbsent(hashedName) { Any() }
                synchronized(lock) {
                    if (!cacheFile.exists()) {
                        downloadFile(source, cacheFile)
                    }
                }
                locks.remove(hashedName)
            }

            if (cacheFile.exists()) {
                return ParcelFileDescriptor.open(cacheFile, ParcelFileDescriptor.MODE_READ_ONLY)
            } else {
                Log.w(TAG, "Failed to download cover from $source")
                throw FileNotFoundException("Failed to download cover: $source")
            }
        }

        throw FileNotFoundException("Unsupported scheme/source: $source")
    }

    private fun downloadFile(urlStr: String, destFile: File): Boolean {
        var connection: HttpURLConnection? = null
        val tempFile = File(destFile.parentFile, destFile.name + ".tmp")
        try {
            val url = URL(urlStr)
            connection = url.openConnection() as HttpURLConnection
            connection.connectTimeout = 5000
            connection.readTimeout = 5000
            connection.instanceFollowRedirects = true
            connection.connect()

            if (connection.responseCode !in 200..299) {
                Log.w(TAG, "HTTP error code: ${connection.responseCode} for $urlStr")
                return false
            }

            connection.inputStream.use { input ->
                FileOutputStream(tempFile).use { output ->
                    input.copyTo(output)
                }
            }

            if (tempFile.exists()) {
                if (tempFile.renameTo(destFile)) {
                    return true
                } else {
                    tempFile.delete()
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error downloading cover: $urlStr", e)
            if (tempFile.exists()) {
                tempFile.delete()
            }
        } finally {
            connection?.disconnect()
        }
        return false
    }

    private fun md5(str: String): String {
        val md = MessageDigest.getInstance("MD5")
        val bytes = md.digest(str.toByteArray(Charsets.UTF_8))
        return bytes.joinToString("") { "%02x".format(it) }
    }

    override fun query(
        uri: Uri,
        projection: Array<out String>?,
        selection: String?,
        selectionArgs: Array<out String>?,
        sortOrder: String?
    ): Cursor? = null

    override fun getType(uri: Uri): String {
        val lastSegment = uri.lastPathSegment ?: return "image/*"
        val source = try {
            val decodedBytes = Base64.decode(lastSegment, Base64.URL_SAFE or Base64.NO_PADDING)
            String(decodedBytes, Charsets.UTF_8)
        } catch (e: Exception) {
            ""
        }
        return when {
            source.endsWith(".png", ignoreCase = true) -> "image/png"
            source.endsWith(".gif", ignoreCase = true) -> "image/gif"
            source.endsWith(".webp", ignoreCase = true) -> "image/webp"
            else -> "image/jpeg"
        }
    }

    override fun insert(uri: Uri, values: ContentValues?): Uri? = null

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<out String>?): Int = 0

    override fun update(
        uri: Uri,
        values: ContentValues?,
        selection: String?,
        selectionArgs: Array<out String>?
    ): Int = 0
}
