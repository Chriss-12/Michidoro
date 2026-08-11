package com.example.pomodoro_app_v1

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class RoutineReminderRestoreReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val rebuildLocalTime = intent.action == Intent.ACTION_TIME_CHANGED ||
            intent.action == Intent.ACTION_TIMEZONE_CHANGED
        RoutineReminderSchedulerNative.restore(context, rebuildLocalTime)
    }
}
