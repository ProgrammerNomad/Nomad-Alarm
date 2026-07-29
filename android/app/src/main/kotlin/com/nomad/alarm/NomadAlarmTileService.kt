package com.nomad.alarm

import android.content.ComponentName
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin

class NomadAlarmTileService : TileService() {

    override fun onStartListening() {
        super.onStartListening()
        refreshTile()
    }

    override fun onClick() {
        val prefs = HomeWidgetPlugin.getData(this)
        val active = prefs.getBoolean("tile_active", prefs.getBoolean("active", false))
        val alarmId = prefs.getInt("tile_alarm_id", prefs.getInt("alarmId", -1))
        val route = if (active && alarmId > 0) {
            "/alarm/active/$alarmId"
        } else {
            "/home"
        }
        val uri = Uri.parse("nomadalarm://tile?route=$route")
        val intent = HomeWidgetLaunchIntent.getActivity(this, MainActivity::class.java, uri)
        startActivityAndCollapse(intent)
    }

    private fun refreshTile() {
        val tile = qsTile ?: return
        val prefs = HomeWidgetPlugin.getData(this)
        val active = prefs.getBoolean("tile_active", prefs.getBoolean("active", false))
        val label = prefs.getString("tile_label", "Nomad Alarm") ?: "Nomad Alarm"
        val subtitle = prefs.getString("tile_subtitle", "")
            ?: prefs.getString("widget_tap_to_open", "Tap to open")
            ?: "Tap to open"

        tile.label = label
        tile.subtitle = subtitle
        tile.state = if (active) Tile.STATE_ACTIVE else Tile.STATE_INACTIVE
        tile.updateTile()
    }

    companion object {
        fun requestUpdate(context: android.content.Context) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                val component = ComponentName(context, NomadAlarmTileService::class.java)
                requestListeningState(context, component)
            }
        }
    }
}
