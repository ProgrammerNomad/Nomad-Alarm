package com.nomad.alarm.wear

import android.content.ComponentName
import androidx.wear.watchface.complications.datasource.ComplicationDataSourceUpdateRequester
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.WearableListenerService
import org.json.JSONObject

class WearDataListenerService : WearableListenerService() {
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        for (event in dataEvents) {
            if (event.type != DataEvent.TYPE_CHANGED) continue
            val item = event.dataItem
            if (item.uri.path != "/nomad/alarm") continue
            val payload = item.data ?: continue
            val json = JSONObject(String(payload, Charsets.UTF_8))
            AlarmWearStore.saveFromJson(this, json)
            ComplicationDataSourceUpdateRequester
                .create(this, ComponentName(this, NomadComplicationService::class.java))
                .requestUpdateAll()
        }
    }
}
