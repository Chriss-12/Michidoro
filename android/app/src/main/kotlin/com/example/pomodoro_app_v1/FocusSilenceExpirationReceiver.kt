package com.example.pomodoro_app_v1

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class FocusSilenceExpirationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val focusSilence = FocusSilenceNative(context.applicationContext)
        if (intent.action == FocusSilenceNative.ACTION_EXPIRE ||
            intent.action == FocusSilenceNative.ACTION_STOP
        ) {
            focusSilence.deactivateOwnedRule()
            return
        }
        focusSilence.restoreAfterSystemEvent()
    }
}
