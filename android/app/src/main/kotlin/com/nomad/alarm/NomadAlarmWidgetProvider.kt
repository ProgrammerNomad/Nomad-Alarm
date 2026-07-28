package com.nomad.alarm

import android.appwidget.AppWidgetManager
import android.content.Context
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

open class NomadAlarmWidgetProvider(
    private val layoutId: Int,
) : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val active = widgetData.getBoolean("active", false)
            val destination =
                widgetData.getString("destination", "No active alarm") ?: "No active alarm"
            val distance = widgetData.getString("distance", "") ?: ""
            val alarmId = widgetData.getInt("alarmId", -1)

            val views = RemoteViews(context.packageName, layoutId).apply {
                setTextViewText(R.id.widget_destination, destination)
                setTextViewText(
                    R.id.widget_distance,
                    if (active && distance.isNotEmpty()) distance else if (active) "Tracking…" else "Tap to open",
                )

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
    NomadAlarmWidgetProvider(R.layout.nomad_alarm_widget_medium)
