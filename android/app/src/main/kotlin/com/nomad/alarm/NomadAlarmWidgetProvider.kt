package com.nomad.alarm

import android.appwidget.AppWidgetManager
import android.content.Context
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

open class NomadAlarmWidgetProvider(
    private val layoutId: Int,
    private val showProgress: Boolean = false,
    private val showSpeed: Boolean = false,
) : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences,
    ) {
        val idleLabel =
            widgetData.getString("widget_no_active", "No active alarm") ?: "No active alarm"
        val trackingLabel =
            widgetData.getString("widget_tracking", "Tracking…") ?: "Tracking…"
        val tapToOpen =
            widgetData.getString("widget_tap_to_open", "Tap to open") ?: "Tap to open"
        val widgetLabel =
            widgetData.getString("widget_label", "Nomad Alarm") ?: "Nomad Alarm"

        appWidgetIds.forEach { widgetId ->
            val active = widgetData.getBoolean("active", false)
            val destination =
                widgetData.getString("destination", idleLabel) ?: idleLabel
            val distance = widgetData.getString("distance", "") ?: ""
            val alarmId = widgetData.getInt("alarmId", -1)
            val progress = widgetData.getInt("progress", 0)
            val speed = widgetData.getString("speed", "") ?: ""

            val views = RemoteViews(context.packageName, layoutId).apply {
                setTextViewText(R.id.widget_destination, destination)
                setTextViewText(
                    R.id.widget_distance,
                    when {
                        active && distance.isNotEmpty() -> distance
                        active -> trackingLabel
                        else -> tapToOpen
                    },
                )

                if (showProgress) {
                    setViewVisibility(R.id.widget_progress, if (active) View.VISIBLE else View.GONE)
                    setProgressBar(R.id.widget_progress, 100, progress, false)
                }

                if (showSpeed) {
                    setViewVisibility(R.id.widget_speed, if (active && speed.isNotEmpty()) View.VISIBLE else View.GONE)
                    setTextViewText(R.id.widget_speed, speed)
                }

                if (showProgress || showSpeed) {
                    setTextViewText(R.id.widget_label, widgetLabel)
                }

                val route = if (active && alarmId > 0) {
                    "/alarm/active/$alarmId"
                } else {
                    "/home"
                }
                val uri = Uri.parse("nomadalarm://widget?route=$route")
                val pendingIntent =
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, uri)
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

class NomadAlarmSmallWidgetProvider : NomadAlarmWidgetProvider(R.layout.nomad_alarm_widget)

class NomadAlarmMediumWidgetProvider :
    NomadAlarmWidgetProvider(R.layout.nomad_alarm_widget_medium, showProgress = true)

class NomadAlarmLargeWidgetProvider :
    NomadAlarmWidgetProvider(
        R.layout.nomad_alarm_widget_large,
        showProgress = true,
        showSpeed = true,
    )
