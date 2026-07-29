package com.nomad.alarm.wear

import android.content.Context
import org.json.JSONObject

object AlarmWearStore {
    private const val PREFS = "nomad_alarm_wear"
    private const val KEY_ACTIVE = "active"
    private const val KEY_DESTINATION = "destination"
    private const val KEY_DISTANCE_METERS = "distanceMeters"
    private const val KEY_ETA_MINUTES = "etaMinutes"

    data class Snapshot(
        val active: Boolean,
        val destination: String?,
        val distanceMeters: Double?,
        val etaMinutes: Double?,
    )

    fun saveFromJson(context: Context, json: JSONObject) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit().apply {
            putBoolean(KEY_ACTIVE, json.optBoolean("active", false))
            putString(KEY_DESTINATION, json.optString("destination").takeIf { it.isNotEmpty() })
            if (json.isNull("distanceMeters")) {
                remove(KEY_DISTANCE_METERS)
            } else {
                putFloat(KEY_DISTANCE_METERS, json.getDouble("distanceMeters").toFloat())
            }
            if (json.isNull("etaMinutes")) {
                remove(KEY_ETA_MINUTES)
            } else {
                putFloat(KEY_ETA_MINUTES, json.getDouble("etaMinutes").toFloat())
            }
        }.apply()
    }

    fun load(context: Context): Snapshot {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        return Snapshot(
            active = prefs.getBoolean(KEY_ACTIVE, false),
            destination = prefs.getString(KEY_DESTINATION, null),
            distanceMeters = if (prefs.contains(KEY_DISTANCE_METERS)) {
                prefs.getFloat(KEY_DISTANCE_METERS, 0f).toDouble()
            } else {
                null
            },
            etaMinutes = if (prefs.contains(KEY_ETA_MINUTES)) {
                prefs.getFloat(KEY_ETA_MINUTES, 0f).toDouble()
            } else {
                null
            },
        )
    }
}
