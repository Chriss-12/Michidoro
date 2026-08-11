package com.example.pomodoro_app_v1

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar

internal data class RoutineReminderAlarm(
    val id: String,
    val title: String,
    val body: String,
    val scheduledAtMillis: Long,
    val year: Int,
    val month: Int,
    val day: Int,
    val hour: Int,
    val minute: Int,
)

internal object RoutineReminderSchedulerNative {
    private const val preferencesName = "routine_reminders"
    private const val remindersKey = "reminders"

    fun replace(context: Context, rawReminders: List<Map<String, Any>>) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val preferences = context.getSharedPreferences(preferencesName, Context.MODE_PRIVATE)
        read(preferences.getString(remindersKey, null)).forEach { reminder ->
            alarmManager.cancel(pendingIntent(context, reminder))
        }
        val reminders = rawReminders.mapNotNull(::fromMap)
        preferences.edit().putString(remindersKey, encode(reminders)).apply()
        reminders.forEach { schedule(context, alarmManager, it) }
    }

    fun restore(context: Context, rebuildLocalTime: Boolean) {
        val preferences = context.getSharedPreferences(preferencesName, Context.MODE_PRIVATE)
        val stored = read(preferences.getString(remindersKey, null))
        val reminders = if (rebuildLocalTime) {
            stored.map { reminder ->
                reminder.copy(
                    scheduledAtMillis = Calendar.getInstance().run {
                        set(Calendar.YEAR, reminder.year)
                        set(Calendar.MONTH, reminder.month - 1)
                        set(Calendar.DAY_OF_MONTH, reminder.day)
                        set(Calendar.HOUR_OF_DAY, reminder.hour)
                        set(Calendar.MINUTE, reminder.minute)
                        set(Calendar.SECOND, 0)
                        set(Calendar.MILLISECOND, 0)
                        timeInMillis
                    },
                )
            }
        } else {
            stored
        }
        preferences.edit().putString(remindersKey, encode(reminders)).apply()
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        reminders.forEach { schedule(context, alarmManager, it) }
    }

    private fun schedule(
        context: Context,
        alarmManager: AlarmManager,
        reminder: RoutineReminderAlarm,
    ) {
        if (reminder.scheduledAtMillis <= System.currentTimeMillis()) return
        val operation = pendingIntent(context, reminder)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
            !alarmManager.canScheduleExactAlarms()) {
            alarmManager.setAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                reminder.scheduledAtMillis,
                operation,
            )
        } else {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                reminder.scheduledAtMillis,
                operation,
            )
        }
    }

    private fun pendingIntent(
        context: Context,
        reminder: RoutineReminderAlarm,
    ): PendingIntent {
        val notificationId = reminder.id.hashCode()
        val intent = Intent(context, RoutineReminderReceiver::class.java).apply {
            data = Uri.parse("michifocus://routine-reminder/${reminder.id}")
            putExtra("id", notificationId)
            putExtra("title", reminder.title)
            putExtra("body", reminder.body)
        }
        return PendingIntent.getBroadcast(
            context,
            notificationId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun fromMap(source: Map<String, Any>): RoutineReminderAlarm? {
        return RoutineReminderAlarm(
            id = source["id"] as? String ?: return null,
            title = source["title"] as? String ?: "MichiDoro",
            body = source["body"] as? String ?: "Actividad pendiente.",
            scheduledAtMillis = (source["scheduledAtMillis"] as? Number)?.toLong()
                ?: return null,
            year = (source["year"] as? Number)?.toInt() ?: return null,
            month = (source["month"] as? Number)?.toInt() ?: return null,
            day = (source["day"] as? Number)?.toInt() ?: return null,
            hour = (source["hour"] as? Number)?.toInt() ?: return null,
            minute = (source["minute"] as? Number)?.toInt() ?: return null,
        )
    }

    private fun encode(reminders: List<RoutineReminderAlarm>): String {
        val array = JSONArray()
        reminders.forEach { reminder ->
            array.put(
                JSONObject()
                    .put("id", reminder.id)
                    .put("title", reminder.title)
                    .put("body", reminder.body)
                    .put("scheduledAtMillis", reminder.scheduledAtMillis)
                    .put("year", reminder.year)
                    .put("month", reminder.month)
                    .put("day", reminder.day)
                    .put("hour", reminder.hour)
                    .put("minute", reminder.minute),
            )
        }
        return array.toString()
    }

    private fun read(encoded: String?): List<RoutineReminderAlarm> {
        if (encoded.isNullOrBlank()) return emptyList()
        return runCatching {
            val array = JSONArray(encoded)
            List(array.length()) { index ->
                val value = array.getJSONObject(index)
                RoutineReminderAlarm(
                    id = value.getString("id"),
                    title = value.getString("title"),
                    body = value.getString("body"),
                    scheduledAtMillis = value.getLong("scheduledAtMillis"),
                    year = value.getInt("year"),
                    month = value.getInt("month"),
                    day = value.getInt("day"),
                    hour = value.getInt("hour"),
                    minute = value.getInt("minute"),
                )
            }
        }.getOrDefault(emptyList())
    }
}
