package de.vito0912.yaabsa

import android.bluetooth.BluetoothClass
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.support.v4.media.session.PlaybackStateCompat
import android.util.Log
import androidx.media.session.MediaButtonReceiver

class BackgroundConnectionReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "BackgroundReceiver"
        @Volatile
        private var lastTriggerTime = 0L
        private const val DEBOUNCE_MS = 5000L
        private const val AUTO_RESUME_BLUETOOTH_PREFERENCE = "auto_resume_bluetooth"
        private const val AUTO_RESUME_RESTRICTED_DEVICES_PREFERENCE = "auto_resume_bluetooth_selected_devices_only"
        private const val AUTO_RESUME_DEVICE_ADDRESSES_PREFERENCE = "auto_resume_bluetooth_device_addresses"
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != BluetoothDevice.ACTION_ACL_CONNECTED) return

        val prefs = context.getSharedPreferences("yaabsa_settings", Context.MODE_PRIVATE)
        val autoResumeBluetooth = prefs.getBoolean(AUTO_RESUME_BLUETOOTH_PREFERENCE, false)
        Log.d(TAG, "ACL_CONNECTED received. Setting enabled: $autoResumeBluetooth")

        if (!autoResumeBluetooth) return

        val restrictToSelectedDevices = prefs.getBoolean(AUTO_RESUME_RESTRICTED_DEVICES_PREFERENCE, false)
        val selectedDeviceAddresses = prefs.getStringSet(AUTO_RESUME_DEVICE_ADDRESSES_PREFERENCE, emptySet()).orEmpty()

        val device = @Suppress("DEPRECATION") (intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE) as? BluetoothDevice)
        val deviceClass = try {
            device?.bluetoothClass
        } catch (e: SecurityException) {
            Log.e(TAG, "SecurityException reading bluetoothClass: ${e.message}")
            null
        }

        val isAudio = deviceClass?.majorDeviceClass == BluetoothClass.Device.Major.AUDIO_VIDEO

        if (!isAudio) {
            Log.d(TAG, "Device is not an audio device. Skipping auto resume.")
            return
        }

        if (restrictToSelectedDevices) {
            val deviceAddress = try {
                device?.address?.trim()?.uppercase()
            } catch (_: SecurityException) {
                null
            }
            if (deviceAddress == null || deviceAddress !in selectedDeviceAddresses) {
                Log.d(TAG, "Connected audio device is not selected. Skipping auto resume.")
                return
            }
        }

        val currentTime = System.currentTimeMillis()
        if (currentTime - lastTriggerTime < DEBOUNCE_MS) {
            Log.d(TAG, "Debouncing: skipped (${currentTime - lastTriggerTime}ms since last)")
            return
        }
        lastTriggerTime = currentTime

        Log.d(TAG, "Triggering play via media button intent")
        try {
            val pendingIntent = MediaButtonReceiver.buildMediaButtonPendingIntent(
                context,
                PlaybackStateCompat.ACTION_PLAY
            )
            pendingIntent?.send()
            Log.d(TAG, "Sent ACTION_PLAY media button pending intent")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to send media button intent: ${e.message}")
        }
    }
}
