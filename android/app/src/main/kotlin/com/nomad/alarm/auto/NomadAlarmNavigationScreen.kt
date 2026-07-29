package com.nomad.alarm.auto

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.model.Action
import androidx.car.app.model.CarText
import androidx.car.app.model.MessageTemplate
import androidx.car.app.model.Template
import androidx.car.app.navigation.model.MessageInfo
import androidx.car.app.navigation.model.NavigationTemplate
import es.antonborri.home_widget.HomeWidgetPlugin

class NomadAlarmNavigationScreen(carContext: CarContext) : Screen(carContext) {

    override fun onGetTemplate(): Template {
        val prefs = HomeWidgetPlugin.getData(carContext)
        val active = prefs.getBoolean("active", false)
        val destination =
            prefs.getString("destination", "")?.trim().orEmpty()
        val distance = prefs.getString("distance", "")?.trim().orEmpty()
        val tileSubtitle =
            prefs.getString("tile_subtitle", "")?.trim().orEmpty()
        val idleLabel =
            prefs.getString("widget_no_active", "No active alarm") ?: "No active alarm"
        val tapToOpen =
            prefs.getString("widget_tap_to_open", "Tap to open") ?: "Tap to open"

        if (!active) {
            val body = destination.ifEmpty { idleLabel }
            return MessageTemplate.Builder(body)
                .setTitle("Nomad Alarm")
                .setHeaderAction(Action.APP_ICON)
                .build()
        }

        val detail = when {
            distance.isNotEmpty() -> distance
            tileSubtitle.isNotEmpty() -> tileSubtitle
            else -> tapToOpen
        }
        val roadText =
            if (destination.isNotEmpty()) "$destination\n$detail" else detail

        return NavigationTemplate.Builder()
            .setNavigationInfo(
                MessageInfo.Builder(CarText.create(roadText)).build(),
            )
            .build()
    }
}
