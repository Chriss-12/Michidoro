package com.example.pomodoro_app_v1

import android.app.AutomaticZenRule
import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.service.notification.Condition
import android.text.format.DateFormat
import java.util.Date

class FocusSilenceNative(private val context: Context) {
    private val notificationManager =
        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    private val preferences =
        context.getSharedPreferences(PREFERENCES_NAME, Context.MODE_PRIVATE)
    private val conditionId = Uri.parse("condition://${context.packageName}/focus_silence")

    fun capability(): Map<String, Any> {
        val supported = Build.VERSION.SDK_INT >= Build.VERSION_CODES.N
        val authorized = supported && notificationManager.isNotificationPolicyAccessGranted
        val active = authorized && ownedRuleIsActive()
        return mapOf(
            "supported" to supported,
            "authorized" to authorized,
            "active" to active,
            "apiLevel" to Build.VERSION.SDK_INT,
        )
    }

    fun openPolicyAccessSettings() {
        val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        context.startActivity(intent)
    }

    fun setActive(active: Boolean, profile: String, endsAtEpochMillis: Long?): Map<String, Any> {
        require(Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            "El silencio de enfoque requiere Android 7 o posterior."
        }
        check(notificationManager.isNotificationPolicyAccessGranted) {
            "Android todavía no autorizó el acceso a No molestar."
        }

        preferences.edit()
            .putBoolean(KEY_DESIRED_ACTIVE, active)
            .putString(KEY_PROFILE, profile)
            .putLong(KEY_ENDS_AT, endsAtEpochMillis ?: 0L)
            .apply()

        if (active) {
            val ruleId = ensureOwnedRule(profile)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                notificationManager.setAutomaticZenRuleState(ruleId, condition(true))
            } else {
                FocusSilenceConditionProvider.publish(context, true)
            }
        } else {
            val ruleId = findOwnedRuleId()
            if (ruleId != null) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    notificationManager.setAutomaticZenRuleState(ruleId, condition(false))
                } else {
                    FocusSilenceConditionProvider.publish(context, false)
                }
            }
        }
        if (active && endsAtEpochMillis != null) {
            scheduleExpiration(endsAtEpochMillis)
            showActiveNotification(endsAtEpochMillis)
        } else {
            cancelExpiration()
            cancelActiveNotification()
        }
        return capability()
    }

    fun restoreAfterSystemEvent() {
        if (!preferences.getBoolean(KEY_DESIRED_ACTIVE, false)) return
        val endsAt = preferences.getLong(KEY_ENDS_AT, 0L)
        if (endsAt <= System.currentTimeMillis()) {
            deactivateOwnedRule()
            return
        }
        if (!notificationManager.isNotificationPolicyAccessGranted) return
        setActive(
            true,
            preferences.getString(KEY_PROFILE, null) ?: "alarmsOnly",
            endsAt,
        )
    }

    fun deactivateOwnedRule() {
        preferences.edit()
            .putBoolean(KEY_DESIRED_ACTIVE, false)
            .putLong(KEY_ENDS_AT, 0L)
            .apply()
        cancelExpiration()
        cancelActiveNotification()
        if (!notificationManager.isNotificationPolicyAccessGranted) return
        val ruleId = findOwnedRuleId() ?: return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            notificationManager.setAutomaticZenRuleState(ruleId, condition(false))
        } else {
            FocusSilenceConditionProvider.publish(context, false)
        }
    }

    private fun ownedRuleIsActive(): Boolean {
        val ruleId = findOwnedRuleId() ?: return false
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.VANILLA_ICE_CREAM) {
            notificationManager.getAutomaticZenRuleState(ruleId) == Condition.STATE_TRUE
        } else {
            preferences.getBoolean(KEY_DESIRED_ACTIVE, false) &&
                notificationManager.getAutomaticZenRule(ruleId)?.isEnabled == true
        }
    }

    private fun ensureOwnedRule(profile: String): String {
        val interruptionFilter = when (profile) {
            PROFILE_NO_INTERRUPTIONS -> NotificationManager.INTERRUPTION_FILTER_NONE
            else -> NotificationManager.INTERRUPTION_FILTER_ALARMS
        }
        val existingId = findOwnedRuleId()
        if (existingId != null) {
            if (preferences.getString(KEY_PROFILE, null) == profile) return existingId
            val rule = createRule(interruptionFilter)
            notificationManager.updateAutomaticZenRule(existingId, rule)
            preferences.edit().putString(KEY_RULE_ID, existingId).apply()
            return existingId
        }

        val createdId = requireNotNull(
            notificationManager.addAutomaticZenRule(createRule(interruptionFilter)),
        ) {
            "Android no pudo crear la regla de Michi Focus."
        }
        preferences.edit().putString(KEY_RULE_ID, createdId).apply()
        return createdId
    }

    private fun findOwnedRuleId(): String? {
        if (!notificationManager.isNotificationPolicyAccessGranted) return null
        val storedId = preferences.getString(KEY_RULE_ID, null)
        if (storedId != null && notificationManager.getAutomaticZenRule(storedId) != null) {
            return storedId
        }
        val recovered = notificationManager.automaticZenRules.entries
            .firstOrNull { (_, rule) -> rule.conditionId == conditionId }
            ?.key
        if (recovered != null) {
            preferences.edit().putString(KEY_RULE_ID, recovered).apply()
        }
        return recovered
    }

    @Suppress("DEPRECATION")
    private fun createRule(interruptionFilter: Int): AutomaticZenRule {
        val activity = ComponentName(context, MainActivity::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.VANILLA_ICE_CREAM) {
            return AutomaticZenRule.Builder(RULE_NAME, conditionId)
                .setConfigurationActivity(activity)
                .setInterruptionFilter(interruptionFilter)
                .setEnabled(true)
                .setType(AutomaticZenRule.TYPE_OTHER)
                .setTriggerDescription("Durante un bloque de enfoque")
                .build()
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            return AutomaticZenRule(
                RULE_NAME,
                null,
                activity,
                conditionId,
                null,
                interruptionFilter,
                true,
            )
        }
        return AutomaticZenRule(
            RULE_NAME,
            ComponentName(context, FocusSilenceConditionProvider::class.java),
            conditionId,
            interruptionFilter,
            true,
        )
    }

    private fun condition(active: Boolean): Condition {
        return Condition(
            conditionId,
            RULE_NAME,
            "Bloque de enfoque",
            "",
            0,
            if (active) Condition.STATE_TRUE else Condition.STATE_FALSE,
            Condition.FLAG_RELEVANT_NOW,
        )
    }

    private fun scheduleExpiration(endsAtEpochMillis: Long) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.setAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            endsAtEpochMillis,
            expirationIntent(),
        )
    }

    private fun cancelExpiration() {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(expirationIntent())
    }

    private fun expirationIntent(): PendingIntent {
        return PendingIntent.getBroadcast(
            context,
            EXPIRATION_REQUEST_CODE,
            Intent(context, FocusSilenceExpirationReceiver::class.java).apply {
                action = ACTION_EXPIRE
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun showActiveNotification(endsAtEpochMillis: Long) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationManager.createNotificationChannel(
                NotificationChannel(
                    NOTIFICATION_CHANNEL_ID,
                    "Silencio de enfoque",
                    NotificationManager.IMPORTANCE_LOW,
                ).apply {
                    description = "Muestra cuándo Michi Focus mantiene activa su regla de enfoque."
                    setSound(null, null)
                },
            )
        }
        val endLabel = DateFormat.getTimeFormat(context).format(Date(endsAtEpochMillis))
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, NOTIFICATION_CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(context)
        }
        val notification = builder
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("Silencio de enfoque activo")
            .setContentText("Las notificaciones volverán a las $endLabel")
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .addAction(
                Notification.Action.Builder(
                    null,
                    "Terminar silencio",
                    stopIntent(),
                ).build(),
            )
            .build()
        notificationManager.notify(NOTIFICATION_ID, notification)
    }

    private fun cancelActiveNotification() {
        notificationManager.cancel(NOTIFICATION_ID)
    }

    private fun stopIntent(): PendingIntent {
        return PendingIntent.getBroadcast(
            context,
            STOP_REQUEST_CODE,
            Intent(context, FocusSilenceExpirationReceiver::class.java).apply {
                action = ACTION_STOP
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    companion object {
        const val PREFERENCES_NAME = "michifocus_focus_silence"
        const val KEY_DESIRED_ACTIVE = "desired_active"
        const val KEY_PROFILE = "profile"
        const val KEY_RULE_ID = "rule_id"
        const val KEY_ENDS_AT = "ends_at"
        const val PROFILE_NO_INTERRUPTIONS = "noInterruptions"
        const val RULE_NAME = "Michi Focus: enfoque"
        const val ACTION_EXPIRE = "com.example.pomodoro_app_v1.FOCUS_SILENCE_EXPIRE"
        const val ACTION_STOP = "com.example.pomodoro_app_v1.FOCUS_SILENCE_STOP"
        const val EXPIRATION_REQUEST_CODE = 4207
        const val STOP_REQUEST_CODE = 4208
        const val NOTIFICATION_CHANNEL_ID = "michifocus_focus_silence"
        const val NOTIFICATION_ID = 4207
    }
}
