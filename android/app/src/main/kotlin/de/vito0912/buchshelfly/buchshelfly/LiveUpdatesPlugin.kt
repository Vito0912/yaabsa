package de.vito0912.yaabsa

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import java.util.Locale
import kotlin.math.ceil

class LiveUpdatesPlugin : FlutterPlugin {
    private lateinit var context: Context
    private lateinit var channel: MethodChannel
    private val handler = Handler(Looper.getMainLooper())
    private var snapshot: Map<*, *> = emptyMap<Any, Any>()
    private var snapshotTime = 0L
    private var mediaId: String? = null
    private var dismissed = false
    private var lastContent: String? = null
    private var lastPostedTime = 0L
    private var lastMode = "off"
    private var receiverRegistered = false
    private var notificationActive = false
    private var channelCreated = false
    private var promotionRejected = false
    private val platformSupported: Boolean by lazy {
        Build.VERSION.SDK_INT >= 36 &&
            !context.packageManager.hasSystemFeature(PackageManager.FEATURE_AUTOMOTIVE) &&
            !context.packageManager.hasSystemFeature(PackageManager.FEATURE_WATCH) &&
            context.packageManager.getPackageInfo(context.packageName, PackageManager.GET_PERMISSIONS)
                .requestedPermissions.orEmpty().contains("android.permission.POST_PROMOTED_NOTIFICATIONS")
    }
    private val supported: Boolean
        get() {
            if (!platformSupported || promotionRejected) return false
            return try {
                notificationSupported && manager.canPostPromotedNotifications() &&
                    (manager.getNotificationChannel(CHANNEL_ID)?.importance ?: NotificationManager.IMPORTANCE_LOW) > NotificationManager.IMPORTANCE_MIN
            } catch (_: LinkageError) {
                false
            } catch (_: SecurityException) {
                false
            }
        }
    private val notificationSupported: Boolean by lazy {
        val builder = Notification.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_launcher_monochrome)
            .setContentTitle(context.getString(R.string.live_update_channel))
            .setStyle(Notification.ProgressStyle()
                .setProgressSegments(listOf(Notification.ProgressStyle.Segment(1000)))
                .setProgress(0))
            .setOngoing(true)
            .setColorized(false)
            .setExtras(Bundle().apply { putBoolean(Notification.EXTRA_REQUEST_PROMOTED_ONGOING, true) })
        buildLiveUpdate(builder) != null
    }
    private val manager by lazy { context.getSystemService(NotificationManager::class.java) }
    private val dismissAction by lazy { "${context.packageName}.DISMISS_LIVE_UPDATE" }
    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action == dismissAction && intent.getStringExtra("mediaId") == mediaId) {
                dismissed = true
                cancel()
            }
        }
    }
    private val tick = object : Runnable {
        override fun run() {
            if (render()) handler.postDelayed(this, 1000L)
        }
    }
    private val verifyPromotion = Runnable {
        if (notificationActive) {
            val posted = manager.activeNotifications.firstOrNull { it.id == NOTIFICATION_ID }
            if (posted != null && posted.notification.flags and Notification.FLAG_PROMOTED_ONGOING == 0) {
                promotionRejected = true
                cancel()
            }
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "de.vito0912.yaabsa/live_updates")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "isLiveUpdatesSupported" -> {
                    val available = supported
                    if (!available) cancel()
                    result.success(available)
                }
                "update" -> {
                    if (supported) {
                        val next = call.arguments as? Map<*, *> ?: emptyMap<Any, Any>()
                        val nextId = next["mediaId"] as? String
                        val nextMode = next["mode"] as? String ?: "off"
                        if (nextId != mediaId || (lastMode == "off" && nextMode != "off")) {
                            dismissed = false
                        }
                        mediaId = nextId
                        lastMode = nextMode
                        snapshot = next
                        snapshotTime = SystemClock.elapsedRealtime()
                        handler.removeCallbacks(tick)
                        tick.run()
                    } else {
                        cancel()
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        cancel()
    }

    private fun cancel() {
        handler.removeCallbacks(tick)
        handler.removeCallbacks(verifyPromotion)
        lastContent = null
        if (notificationActive) {
            manager.cancel(NOTIFICATION_ID)
            notificationActive = false
        }
        if (receiverRegistered) {
            context.unregisterReceiver(receiver)
            receiverRegistered = false
        }
    }

    private fun render(): Boolean {
        if (!supported) {
            cancel()
            return false
        }
        val mode = snapshot["mode"] as? String ?: "off"
        val title = snapshot["title"] as? String ?: ""
        if (mode !in MODES || snapshot["playing"] != true || title.isBlank() || dismissed) {
            cancel()
            return false
        }
        val duration = number("durationMs").toLong().coerceAtLeast(0L)
        val speed = number("speed").takeIf { it.isFinite() && it > 0 } ?: 1.0
        val elapsedRealtime = SystemClock.elapsedRealtime() - snapshotTime
        val elapsed = (elapsedRealtime * speed).toLong()
        val sleepRemaining = (number("sleepTimerRemainingMs").toLong() - elapsedRealtime).coerceAtLeast(0L)
        if (mode == "sleepTimer" && (snapshot["sleepTimerRunning"] != true || sleepRemaining == 0L)) {
            cancel()
            return false
        }
        val position = (number("positionMs").toLong() + elapsed).coerceAtLeast(0L)
        if (duration > 0L && position >= duration && (mode == "currentTime" || mode == "remainingTime")) {
            cancel()
            return true
        }
        val percentage = if (duration > 0L) ((position.toDouble() / duration) * 100).toInt().coerceIn(0, 100) else null
        val time = when (mode) {
            "currentTime" -> position
            "sleepTimer" -> sleepRemaining
            "remainingTime" -> ceil((duration - position).coerceAtLeast(0L) / speed).toLong()
            else -> 0L
        }
        val formattedTime = if (mode == "progressPercentage") "" else formatTime(time)
        val chip = when (mode) {
            "progressPercentage" -> if (percentage == null) "?" else "$percentage%"
            "remainingTime" -> if (duration == 0L) "?" else formattedTime
            else -> formattedTime
        }
        val text = when (mode) {
            "sleepTimer" -> context.getString(R.string.live_update_sleep_timer, formattedTime)
            "progressPercentage" -> if (percentage == null) context.getString(R.string.live_update_unknown_duration)
                else context.getString(R.string.live_update_percentage, percentage)
            "remainingTime" -> if (duration == 0L) context.getString(R.string.live_update_unknown_duration)
                else context.getString(R.string.live_update_remaining, formattedTime)
            else -> context.getString(R.string.live_update_elapsed, formattedTime)
        }
        val progressDuration = if (mode == "sleepTimer") number("sleepTimerTotalMs").toLong() else duration
        val progressPosition = if (mode == "sleepTimer") progressDuration - sleepRemaining else position
        val progress = if (progressDuration > 0L) ((progressPosition.toDouble() / progressDuration) * 1000).toInt().coerceIn(0, 1000) else 0
        val content = "$mediaId|$title|$mode|$text|$progress"
        if (content == lastContent && SystemClock.elapsedRealtime() - lastPostedTime < 10000L) return true
        if (context.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            return true
        }
        if (!receiverRegistered) {
            context.registerReceiver(receiver, IntentFilter(dismissAction), Context.RECEIVER_NOT_EXPORTED)
            receiverRegistered = true
        }
        if (!channelCreated) {
            val notificationChannel = NotificationChannel(CHANNEL_ID, context.getString(R.string.live_update_channel), NotificationManager.IMPORTANCE_LOW)
            notificationChannel.setSound(null, null)
            notificationChannel.enableVibration(false)
            notificationChannel.setShowBadge(false)
            manager.createNotificationChannel(notificationChannel)
            channelCreated = true
        }
        val openIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val open = PendingIntent.getActivity(context, NOTIFICATION_ID, openIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val delete = PendingIntent.getBroadcast(context, NOTIFICATION_ID,
            Intent(dismissAction).setPackage(context.packageName).putExtra("mediaId", mediaId),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val extras = Bundle().apply { putBoolean(Notification.EXTRA_REQUEST_PROMOTED_ONGOING, true) }
        val style = Notification.ProgressStyle()
            .setProgressSegments(listOf(Notification.ProgressStyle.Segment(1000)))
            .setProgress(progress)
            .setProgressIndeterminate(progressDuration == 0L)
        val builder = Notification.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_launcher_monochrome)
            .setContentTitle(title)
            .setContentText(text)
            .setShortCriticalText(chip)
            .setStyle(style)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setLocalOnly(true)
            .setShowWhen(false)
            .setColorized(false)
            .setContentIntent(open)
            .setDeleteIntent(delete)
            .setExtras(extras)
            .setTimeoutAfter(15000L)
        val notification = buildLiveUpdate(builder)
        if (notification == null) {
            promotionRejected = true
            cancel()
            return false
        }
        try {
            manager.notify(NOTIFICATION_ID, notification)
            notificationActive = true
            if (!handler.hasCallbacks(verifyPromotion)) {
                handler.postDelayed(verifyPromotion, 500L)
            }
            lastContent = content
            lastPostedTime = SystemClock.elapsedRealtime()
        } catch (_: SecurityException) {
        }
        return true
    }

    private fun buildLiveUpdate(builder: Notification.Builder): Notification? {
        var notification = builder.build()
        // Early Android 16 uses colorization as the promotion request.
        if (!notification.hasPromotableCharacteristics()) {
            notification = builder.setColorized(true).build()
        }
        return notification.takeIf { it.hasPromotableCharacteristics() }
    }

    private fun number(key: String): Double = (snapshot[key] as? Number)?.toDouble() ?: 0.0

    private fun formatTime(milliseconds: Long): String {
        val seconds = milliseconds / 1000
        val hours = seconds / 3600
        if (hours == 0L) return String.format(Locale.ROOT, "%02d:%02d", seconds / 60, seconds % 60)
        return String.format(Locale.ROOT, "%02d:%02d:%02d", hours, (seconds / 60) % 60, seconds % 60)
    }

    companion object {
        private const val CHANNEL_ID = "yaabsa_live_updates"
        private const val NOTIFICATION_ID = 1600912
        private val MODES = setOf("currentTime", "remainingTime", "sleepTimer", "progressPercentage")
    }
}
