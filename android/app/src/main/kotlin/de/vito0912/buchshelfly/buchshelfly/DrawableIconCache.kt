package de.vito0912.yaabsa

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.os.ParcelFileDescriptor
import java.io.File
import java.io.FileNotFoundException
import java.util.concurrent.ConcurrentHashMap

object DrawableIconCache {
    private const val ICON_SIZE = 192
    private val locks = ConcurrentHashMap<String, Any>()

    fun open(context: Context, name: String): ParcelFileDescriptor {
        if (!name.matches(Regex("[a-z0-9_]+"))) {
            throw FileNotFoundException("Invalid icon name")
        }

        val resourceId = context.resources.getIdentifier(name, "drawable", context.packageName)
        if (resourceId == 0) {
            throw FileNotFoundException("Unknown icon resource: $name")
        }

        val version = context.packageManager.getPackageInfo(context.packageName, 0).lastUpdateTime
        val directory = File(context.cacheDir, "car_icons")
        if (!directory.isDirectory && !directory.mkdirs()) {
            throw FileNotFoundException("Icon cache is unavailable")
        }

        val file = File(directory, "${version}_$name.png")
        val lock = locks.computeIfAbsent(file.name) { Any() }

        try {
            synchronized(lock) {
                if (!file.exists()) {
                    val drawable = context.getDrawable(resourceId)?.mutate()
                        ?: throw FileNotFoundException("Icon cannot be loaded")
                    val bitmap = Bitmap.createBitmap(ICON_SIZE, ICON_SIZE, Bitmap.Config.ARGB_8888)
                    val temporary = File(directory, "${file.name}.tmp")

                    try {
                        drawable.setTint(Color.WHITE)
                        drawable.setBounds(0, 0, ICON_SIZE, ICON_SIZE)
                        drawable.draw(Canvas(bitmap))

                        temporary.outputStream().use { output ->
                            if (!bitmap.compress(Bitmap.CompressFormat.PNG, 100, output)) {
                                throw FileNotFoundException("Icon cannot be rendered")
                            }
                        }

                        if (!temporary.renameTo(file)) {
                            throw FileNotFoundException("Icon cannot be cached")
                        }
                    } finally {
                        temporary.delete()
                        bitmap.recycle()
                    }
                }
            }
        } finally {
            locks.remove(file.name, lock)
        }

        return ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY)
    }
}
