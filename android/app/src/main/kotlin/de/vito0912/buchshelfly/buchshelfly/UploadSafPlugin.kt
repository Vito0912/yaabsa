package de.vito0912.yaabsa

import android.content.ContentResolver
import android.net.Uri
import android.provider.DocumentsContract
import android.provider.OpenableColumns
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.io.InputStream
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class UploadSafPlugin : FlutterPlugin {
    private lateinit var resolver: ContentResolver
    private var channel: MethodChannel? = null
    private var worker: ExecutorService? = null
    private val streams = mutableMapOf<Int, InputStream>()
    private var nextHandle = 0

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        resolver = binding.applicationContext.contentResolver
        val executor = Executors.newSingleThreadExecutor()
        worker = executor
        channel = MethodChannel(binding.binaryMessenger, "de.vito0912.yaabsa/upload_saf").also {
            it.setMethodCallHandler { call, result ->
                executor.execute {
                    try {
                        result.success(handle(call))
                    } catch (error: Exception) {
                        result.error("saf_upload_failed", error.message, null)
                    }
                }
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        worker?.execute {
            for (stream in streams.values) {
                try {
                    stream.close()
                } catch (_: IOException) {
                }
            }
            streams.clear()
        }
        worker?.shutdown()
        worker = null
    }

    private fun handle(call: MethodCall): Any? {
        return when (call.method) {
            "inspectTree" -> inspectTree(contentUri(call))
            "listDirectory" -> listDirectory(contentUri(call))
            "fileLength" -> fileLength(contentUri(call))
            "openFile" -> {
                check(streams.size < 16) { "Too many open upload files" }
                val stream = resolver.openInputStream(contentUri(call))
                    ?: throw IOException("Could not open upload file")
                val handle = nextHandle++
                streams[handle] = stream
                handle
            }
            "readFile" -> {
                val handle = requireNotNull(call.argument<Int>("handle"))
                val stream = streams[handle] ?: throw IOException("Upload file is closed")
                val buffer = ByteArray(256 * 1024)
                val count = stream.read(buffer)
                if (count < 0) {
                    byteArrayOf()
                } else {
                    buffer.copyOf(count)
                }
            }
            "closeFile" -> {
                val handle = requireNotNull(call.argument<Int>("handle"))
                streams.remove(handle)?.close()
                null
            }
            else -> throw IllegalArgumentException("Unknown SAF upload operation")
        }
    }

    private fun contentUri(call: MethodCall): Uri {
        val uri = Uri.parse(requireNotNull(call.argument<String>("uri")))
        require(uri.scheme == "content") { "Expected a content URI" }
        return uri
    }

    private fun inspectTree(tree: Uri): Map<String, String> {
        val documentId = DocumentsContract.getTreeDocumentId(tree)
        val document = DocumentsContract.buildDocumentUriUsingTree(tree, documentId)
        val projection = arrayOf(
            DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            DocumentsContract.Document.COLUMN_MIME_TYPE,
        )
        resolver.query(document, projection, null, null, null)?.use { cursor ->
            check(cursor.moveToFirst()) { "Selected directory is unavailable" }
            check(cursor.getString(1) == DocumentsContract.Document.MIME_TYPE_DIR) {
                "Selected document is not a directory"
            }
            return mapOf("uri" to document.toString(), "name" to safeName(cursor.getString(0)))
        }
        throw IOException("Could not inspect selected directory")
    }

    private fun listDirectory(directory: Uri): List<Map<String, Any>> {
        val documentId = DocumentsContract.getDocumentId(directory)
        val children = DocumentsContract.buildChildDocumentsUriUsingTree(directory, documentId)
        val projection = arrayOf(
            DocumentsContract.Document.COLUMN_DOCUMENT_ID,
            DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            DocumentsContract.Document.COLUMN_MIME_TYPE,
        )
        val entries = mutableListOf<Map<String, Any>>()
        val cursor = resolver.query(children, projection, null, null, null)
            ?: throw IOException("Could not list selected directory")
        cursor.use {
            while (it.moveToNext()) {
                val uri = DocumentsContract.buildDocumentUriUsingTree(directory, it.getString(0))
                entries.add(mapOf(
                    "uri" to uri.toString(),
                    "name" to safeName(it.getString(1)),
                    "isDirectory" to (it.getString(2) == DocumentsContract.Document.MIME_TYPE_DIR),
                ))
            }
        }
        return entries
    }

    private fun fileLength(uri: Uri): Long {
        resolver.query(uri, arrayOf(OpenableColumns.SIZE), null, null, null)?.use { cursor ->
            if (cursor.moveToFirst() && !cursor.isNull(0)) {
                val size = cursor.getLong(0)
                if (size >= 0) {
                    return size
                }
            }
        }

        val stream = resolver.openInputStream(uri) ?: throw IOException("Could not open upload file")
        stream.use {
            val buffer = ByteArray(256 * 1024)
            var size = 0L
            while (true) {
                val count = it.read(buffer)
                if (count < 0) {
                    return size
                }
                size += count
            }
        }
    }

    private fun safeName(name: String?): String {
        require(!name.isNullOrBlank() && name != "." && name != "..") { "Invalid document name" }
        require(!name.contains('/') && !name.contains('\\') && !name.contains('\u0000')) {
            "Invalid document name"
        }
        return name
    }
}
