package de.vito0912.yaabsa

import android.content.Context

/**
 * Pending watch credential request, shared between [WearSignInListenerService]
 * (which may receive the request before any activity exists) and
 * [MainActivity] (which answers it once the user has signed in).
 */
object WearPairingStore {
    private const val PREFS_NAME = "wear_pairing"
    private const val KEY_NODE_ID = "pending_node_id"
    private const val KEY_REQUEST_ID = "pending_request_id"
    private const val KEY_RECEIVED_AT = "pending_received_at"

    // The watch gives up waiting after this long (WearMainActivity.LOGIN_TIMEOUT),
    // so older requests can no longer be answered.
    private const val MAX_AGE_MS = 300_000L

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    fun savePendingRequest(context: Context, nodeId: String, requestId: String) {
        prefs(context).edit()
            .putString(KEY_NODE_ID, nodeId)
            .putString(KEY_REQUEST_ID, requestId)
            .putLong(KEY_RECEIVED_AT, System.currentTimeMillis())
            .apply()
    }

    /** Returns nodeId to requestId, or null when nothing is pending. */
    fun pendingRequest(context: Context): Pair<String, String>? {
        val p = prefs(context)
        val nodeId = p.getString(KEY_NODE_ID, null) ?: return null
        val requestId = p.getString(KEY_REQUEST_ID, null) ?: return null
        if (System.currentTimeMillis() - p.getLong(KEY_RECEIVED_AT, 0L) > MAX_AGE_MS) {
            clear(context)
            return null
        }
        return nodeId to requestId
    }

    fun clear(context: Context) {
        prefs(context).edit().clear().apply()
    }
}
