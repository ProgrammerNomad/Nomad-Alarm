package com.nomad.alarm

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
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
    }
}
