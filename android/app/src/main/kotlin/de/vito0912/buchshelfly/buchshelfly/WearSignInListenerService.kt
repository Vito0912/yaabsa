package de.vito0912.yaabsa

import android.app.ActivityManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Process
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.WearableListenerService

/**
 * Receives the watch's credential request even when the phone app is not
 * running: Play Services starts this service for messages on [REQUEST_PATH]
 * (see the manifest intent filter). The live listener in [MainActivity]
 * covers the in-app case, so this service only persists the request and, when
 * the app is in the background, posts a notification that opens the wear
 * sign-in flow.
 */
class WearSignInListenerService : WearableListenerService() {

    companion object {
        const val EXTRA_WEAR_SIGN_IN = "wearSignIn"
        const val NOTIFICATION_ID = 0x57EA
        private const val REQUEST_PATH = "/yaabsa/credential_request"
        private const val CHANNEL_ID = "wear_pairing"
    }

    override fun onMessageReceived(event: MessageEvent) {
        if (event.path != REQUEST_PATH) {
            return
        }
        WearPairingStore.savePendingRequest(this, event.sourceNodeId, String(event.data))
        if (isAppInForeground()) {
            // MainActivity's live listener opens the sign-in screen in place.
            return
        }

        // Best effort: starting an activity from the background works before
        // Android 10 and within the grace period after the app was last
        // visible; otherwise the OS silently drops it.
        try {
            startActivity(signInIntent())
        } catch (_: Exception) {
        }

        // Fallback for when the direct start was blocked. MainActivity
        // cancels it as soon as the sign-in screen opens, so it only stays
        // visible when the user actually has to tap it.
        postSignInNotification()
    }

    private fun signInIntent(): Intent = Intent(this, MainActivity::class.java)
        .putExtra(EXTRA_WEAR_SIGN_IN, true)
        .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)

    private fun isAppInForeground(): Boolean {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        return activityManager.runningAppProcesses?.any {
            it.pid == Process.myPid() &&
                it.importance <= ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND
        } ?: false
    }

    private fun postSignInNotification() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(
                NotificationChannel(
                    CHANNEL_ID,
                    getString(R.string.wear_pairing_channel_name),
                    NotificationManager.IMPORTANCE_HIGH,
                )
            )
        }

        val pendingIntent = PendingIntent.getActivity(
            this,
            NOTIFICATION_ID,
            signInIntent(),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_launcher_monochrome)
            .setContentTitle(getString(R.string.wear_sign_in_notification_title))
            .setContentText(getString(R.string.wear_sign_in_notification_text))
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .build()
        // Dropped silently when POST_NOTIFICATIONS is not granted; the user
        // can still open the app manually while the watch keeps waiting.
        NotificationManagerCompat.from(this).notify(NOTIFICATION_ID, notification)
    }
}
