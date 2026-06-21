package com.blackstartlabs.aizen

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import org.json.JSONArray
import java.lang.Exception

class HabitWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val habitsJsonStr = prefs.getString("flutter.habits_list", null)
            
            var habitTitle = "No Active Habit"
            var streakCount = 0
            var label = "START TODAY"

            if (!habitsJsonStr.isNullOrEmpty()) {
                try {
                    val cleanedJson = if (habitsJsonStr.startsWith("\"") && habitsJsonStr.endsWith("\"")) {
                        habitsJsonStr.substring(1, habitsJsonStr.length - 1)
                            .replace("\\\"", "\"")
                            .replace("\\\\", "\\")
                    } else {
                        habitsJsonStr
                    }
                    val jsonArray = JSONArray(cleanedJson)
                    if (jsonArray.length() > 0) {
                        val firstHabit = jsonArray.getJSONObject(0)
                        habitTitle = firstHabit.optString("title", "Streak")
                        streakCount = firstHabit.optInt("currentStreak", 0)
                        label = if (streakCount == 1) "DAY ACTIVE" else "DAYS ACTIVE"
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }

            val views = RemoteViews(context.packageName, R.layout.habit_widget).apply {
                setTextViewText(R.id.widget_habit_title, habitTitle.uppercase())
                setTextViewText(R.id.widget_streak_count, streakCount.toString())
                setTextViewText(R.id.widget_streak_label, label)
            }

            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context, 
                0, 
                intent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_background, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
