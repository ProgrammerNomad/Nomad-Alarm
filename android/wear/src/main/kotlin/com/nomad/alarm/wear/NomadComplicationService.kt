package com.nomad.alarm.wear

import androidx.wear.watchface.complications.data.ComplicationData
import androidx.wear.watchface.complications.data.ComplicationType
import androidx.wear.watchface.complications.data.LongTextComplicationData
import androidx.wear.watchface.complications.data.PlainComplicationText
import androidx.wear.watchface.complications.data.ShortTextComplicationData
import androidx.wear.watchface.complications.datasource.ComplicationDataSourceService
import androidx.wear.watchface.complications.datasource.ComplicationRequest

class NomadComplicationService : ComplicationDataSourceService() {
    override fun onComplicationRequest(
        request: ComplicationRequest,
        listener: ComplicationRequestListener,
    ) {
        listener.onComplicationData(buildComplication(request.complicationType))
    }

    override fun getPreviewData(type: ComplicationType): ComplicationData? {
        return buildComplication(type)
    }

    private fun buildComplication(type: ComplicationType): ComplicationData {
        val snapshot = AlarmWearStore.load(this)
        if (!snapshot.active) {
            val text = PlainComplicationText.Builder(getString(R.string.complication_no_alarm)).build()
            return when (type) {
                ComplicationType.SHORT_TEXT -> ShortTextComplicationData.Builder(text, text).build()
                else -> LongTextComplicationData.Builder(text, text).build()
            }
        }

        val distanceKm = snapshot.distanceMeters?.div(1000.0)
        val distanceLabel = distanceKm?.let { String.format("%.1f km", it) } ?: "--"
        val etaLabel = snapshot.etaMinutes?.let { String.format("%.0f min", it) } ?: "--"
        val shortText = PlainComplicationText.Builder(etaLabel).build()
        val longBody = PlainComplicationText.Builder("$distanceLabel · $etaLabel").build()
        val title = snapshot.destination?.let { PlainComplicationText.Builder(it).build() }

        return when (type) {
            ComplicationType.SHORT_TEXT -> ShortTextComplicationData.Builder(shortText, longBody).apply {
                title?.let { setTitle(it) }
            }.build()
            else -> LongTextComplicationData.Builder(longBody, longBody).apply {
                title?.let { setTitle(it) }
            }.build()
        }
    }
}
