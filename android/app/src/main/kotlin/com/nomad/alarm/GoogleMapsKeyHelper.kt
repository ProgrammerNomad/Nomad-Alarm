package com.nomad.alarm

import android.content.Context
import android.content.pm.PackageManager
import android.util.Log

/**
 * Applies a user-supplied Google Maps API key to application meta-data at runtime.
 * Required because Maps SDK for Android reads [com.google.android.geo.API_KEY] from
 * the manifest; Flutter secure storage cannot update manifest resources directly.
 */
object GoogleMapsKeyHelper {
    private const val TAG = "GoogleMapsKeyHelper"
    private const val PREFS = "nomad_alarm_prefs"
    private const val PREF_KEY = "google_maps_api_key"
    private const val META_DATA_NAME = "com.google.android.geo.API_KEY"

    fun saveKey(context: Context, apiKey: String?) {
        val trimmed = apiKey?.trim().orEmpty()
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .edit()
            .putString(PREF_KEY, trimmed)
            .apply()
        if (trimmed.isNotEmpty()) {
            applyKeyToMetaData(context, trimmed)
        }
    }

    fun loadAndApply(context: Context) {
        val key = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .getString(PREF_KEY, null)
        if (!key.isNullOrBlank()) {
            applyKeyToMetaData(context, key)
        }
    }

    private fun applyKeyToMetaData(context: Context, apiKey: String) {
        try {
            val appInfo = context.packageManager.getApplicationInfo(
                context.packageName,
                PackageManager.GET_META_DATA,
            )
            if (appInfo.metaData == null) {
                appInfo.metaData = android.os.Bundle()
            }
            appInfo.metaData.putString(META_DATA_NAME, apiKey)
        } catch (e: Exception) {
            Log.w(TAG, "Failed to apply Google Maps API key to meta-data", e)
        }
    }
}
