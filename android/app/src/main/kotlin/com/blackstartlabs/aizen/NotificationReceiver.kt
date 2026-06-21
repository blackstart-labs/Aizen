package com.blackstartlabs.aizen

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat

class NotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = "habit_reminder_channel"
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Habit Reminder",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Daily habit builder check-in reminders"
            }
            notificationManager.createNotificationChannel(channel)
        }

        val quotes = listOf(
            "Self-discipline is the bridge between goals and accomplishment.",
            "Great things are done by a series of small things brought together.",
            "Do not yield to temptation; hold on to your resolve.",
            "It does not matter how slowly you go as long as you do not stop.",
            "Continuous improvement is better than delayed perfection.",
            "Watch your habits, they become your character.",
            "The secret of your future is hidden in your daily routine."
        )
        val randomQuote = quotes.random()

        val builder = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle("Aizen Habit Builder")
            .setContentText(randomQuote)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)

        notificationManager.notify(42, builder.build())
    }
}
