package com.nomad.alarm

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.wearable.PutDataRequest
import com.google.android.gms.wearable.Wearable
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader

class MainActivity : FlutterActivity() {
    private var importChannel: MethodChannel? = null
    private var pendingImportPayload: String? = null

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        captureImportIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        captureImportIntent(intent)
        pendingImportPayload?.let { payload ->
            importChannel?.invokeMethod("onImportPayload", payload)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        importChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.nomad.alarm/import",
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "getPendingImport" -> result.success(pendingImportPayload)
                    else -> result.notImplemented()
                }
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.nomad.alarm/tile",
        ).setMethodCallHandler { call, result ->
            if (call.method == "requestTileUpdate") {
                NomadAlarmTileService.requestUpdate(this)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.nomad.alarm/wear",
        ).setMethodCallHandler { call, result ->
            if (call.method == "syncAlarm") {
                val active = call.argument<Boolean>("active") ?: false
                val destination = call.argument<String>("destination")
                val distanceMeters = call.argument<Double>("distanceMeters")
                val etaMinutes = call.argument<Double>("etaMinutes")
                val json = JSONObject().apply {
                    put("active", active)
                    put("destination", destination ?: "")
                    if (distanceMeters != null) {
                        put("distanceMeters", distanceMeters)
                    } else {
                        put("distanceMeters", JSONObject.NULL)
                    }
                    if (etaMinutes != null) {
                        put("etaMinutes", etaMinutes)
                    } else {
                        put("etaMinutes", JSONObject.NULL)
                    }
                }
                val request = PutDataRequest.create("/nomad/alarm")
                    .setData(json.toString().toByteArray(Charsets.UTF_8))
                Wearable.getDataClient(this)
                    .putDataItem(request)
                    .addOnSuccessListener { result.success(null) }
                    .addOnFailureListener { e ->
                        result.error("WEAR_SYNC_FAILED", e.message, null)
                    }
            } else {
                result.notImplemented()
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.nomad.alarm/android_auto",
        ).setMethodCallHandler { call, result ->
            val prefs = es.antonborri.home_widget.HomeWidgetPlugin.getData(this)
            when (call.method) {
                "updateNavigation" -> {
                    val destination = call.argument<String>("destination") ?: ""
                    val distanceLabel = call.argument<String>("distance") ?: ""
                    val etaLabel = call.argument<String>("eta")
                    val combined = if (!etaLabel.isNullOrBlank()) {
                        "$distanceLabel · $etaLabel"
                    } else {
                        distanceLabel
                    }
                    val subtitle = combined.ifBlank { distanceLabel }
                    prefs.edit()
                        .putBoolean("active", true)
                        .putString("destination", destination)
                        .putString("distance", combined)
                        .putString("tile_subtitle", subtitle)
                        .apply()
                    result.success(null)
                }
                "clear" -> {
                    val idleLabel =
                        prefs.getString("widget_no_active", "No active alarm")
                            ?: "No active alarm"
                    val tapToOpen =
                        prefs.getString("widget_tap_to_open", "Tap to open")
                            ?: "Tap to open"
                    prefs.edit()
                        .putBoolean("active", false)
                        .putString("destination", idleLabel)
                        .putString("distance", "")
                        .putString("tile_subtitle", tapToOpen)
                        .apply()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.nomad.alarm/google_maps",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "setGoogleMapsApiKey" -> {
                    val apiKey = call.argument<String>("apiKey")
                    GoogleMapsKeyHelper.saveKey(this, apiKey)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun captureImportIntent(intent: Intent?) {
        if (intent == null) {
            return
        }
        when (intent.action) {
            Intent.ACTION_SEND -> {
                if (intent.type?.startsWith("text/") == true) {
                    pendingImportPayload = intent.getStringExtra(Intent.EXTRA_TEXT)
                } else {
                    val uri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
                    pendingImportPayload = readUriText(uri)
                }
            }
            Intent.ACTION_VIEW -> {
                pendingImportPayload = readUriText(intent.data)
            }
        }
    }

    private fun readUriText(uri: Uri?): String? {
        if (uri == null) {
            return null
        }
        return try {
            contentResolver.openInputStream(uri)?.use { input ->
                BufferedReader(InputStreamReader(input)).readText()
            }
        } catch (_: Exception) {
            null
        }
    }
}
