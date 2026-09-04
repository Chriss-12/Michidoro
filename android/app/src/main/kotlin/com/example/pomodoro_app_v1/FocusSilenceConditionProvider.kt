package com.example.pomodoro_app_v1

import android.content.ComponentName
import android.content.Context
import android.net.Uri
import android.os.Build
import android.service.notification.Condition
import android.service.notification.ConditionProviderService

@Suppress("DEPRECATION")
class FocusSilenceConditionProvider : ConditionProviderService() {
    override fun onConnected() {
        activeInstance = this
        publishStoredState()
    }

    override fun onSubscribe(conditionId: Uri) {
        publishStoredState()
    }

    override fun onUnsubscribe(conditionId: Uri) = Unit

    override fun onDestroy() {
        if (activeInstance === this) activeInstance = null
        super.onDestroy()
    }

    private fun publishStoredState() {
        val preferences = getSharedPreferences(
            FocusSilenceNative.PREFERENCES_NAME,
            Context.MODE_PRIVATE,
        )
        notifyCondition(
            buildCondition(
                this,
                preferences.getBoolean(FocusSilenceNative.KEY_DESIRED_ACTIVE, false),
            ),
        )
    }

    companion object {
        private var activeInstance: FocusSilenceConditionProvider? = null

        fun publish(context: Context, active: Boolean) {
            val instance = activeInstance
            if (instance != null) {
                instance.notifyCondition(buildCondition(context, active))
                return
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                requestRebind(ComponentName(context, FocusSilenceConditionProvider::class.java))
            }
        }

        private fun buildCondition(context: Context, active: Boolean): Condition {
            return Condition(
                Uri.parse("condition://${context.packageName}/focus_silence"),
                FocusSilenceNative.RULE_NAME,
                "Bloque de enfoque",
                "",
                0,
                if (active) Condition.STATE_TRUE else Condition.STATE_FALSE,
                Condition.FLAG_RELEVANT_NOW,
            )
        }
    }
}
