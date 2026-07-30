package com.nomad.alarm

import io.flutter.app.FlutterApplication

class NomadAlarmApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        GoogleMapsKeyHelper.loadAndApply(this)
    }
}
