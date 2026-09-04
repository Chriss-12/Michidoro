package com.example.pomodoro_app_v1

import android.app.Activity
import android.app.AlarmManager
import android.Manifest
import android.app.KeyguardManager
import android.app.NotificationManager
import android.hardware.biometrics.BiometricManager
import android.hardware.biometrics.BiometricPrompt
import android.content.ActivityNotFoundException
import android.content.ClipData
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.media.ToneGenerator
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.CancellationSignal
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.provider.DocumentsContract
import android.util.Log
import android.view.WindowManager
import android.provider.OpenableColumns
import android.provider.Settings
import android.speech.ModelDownloadListener
import android.speech.RecognitionListener
import android.speech.RecognitionSupport
import android.speech.RecognitionSupportCallback
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyPermanentlyInvalidatedException
import android.security.keystore.KeyProperties
import android.security.keystore.UserNotAuthenticatedException
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.ByteArrayOutputStream
import java.io.InputStream
import java.security.KeyStore
import java.security.MessageDigest
import java.util.UUID
import javax.crypto.AEADBadTagException
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

class MainActivity : FlutterActivity() {
    private val channelName = "michifocus/native_files"
    private val routineReminderChannelName = "michifocus/routine_reminders"
    private val localAuthChannelName = "michifocus/local_auth"
    private val deviceIdentityChannelName = "michifocus/device_identity"
    private val groupKeystoreChannelName = "michifocus/group_keystore"
    private val localSpeechChannelName = "michifocus/local_speech"
    private val focusSilenceChannelName = "michifocus/focus_silence"
    private val screenAwakeChannelName = "michifocus/screen_awake"
    private val pickProfileImageRequest = 4101
    private val pickFolderRequest = 4102
    private val pickBackupImportFolderRequest = 4103
    private val localCredentialRequest = 4105
    private val backupFileNames = setOf(
        "michifocus.sqlite",
    )
    private val legacyBackupFileNames = setOf(
        "michifocus_goals.sqlite",
        "michifocus_tasks.sqlite",
        "michifocus_pomodoro_sessions.sqlite",
        "michifocus_calendar_events.sqlite",
    )

    private var pendingResult: MethodChannel.Result? = null
    private var pendingRequestCode: Int? = null
    private var pendingLocalAuthResult: MethodChannel.Result? = null
    private var localAuthCancellationSignal: CancellationSignal? = null
    private lateinit var localSpeechChannel: MethodChannel
    private var localSpeechRecognizer: SpeechRecognizer? = null
    private var localSpeechDownloadRecognizer: SpeechRecognizer? = null
    private var localSpeechDownloadActive = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result -> handleNativeFileCall(call, result) }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, routineReminderChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "replaceRoutineReminders" -> replaceRoutineReminders(call, result)
                    "getRoutineReminderStatus" -> result.success(routineReminderStatus())
                    "openRoutineReminderSettings" -> openRoutineReminderSettings(result)
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, localAuthChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isAvailable" -> result.success(isLocalAuthenticationAvailable())
                    "authenticate" -> authenticateLocally(result)
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, deviceIdentityChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getSuggestedName" -> result.success(suggestedDeviceName())
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, groupKeystoreChannelName)
            .setMethodCallHandler { call, result -> handleGroupKeystoreCall(call, result) }
        localSpeechChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, localSpeechChannelName)
        localSpeechChannel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "downloadModel" -> downloadLocalSpeechModel(call, result)
                    "openLanguageSettings" -> openLocalSpeechLanguageSettings(call, result)
                    "startListening" -> startLocalSpeech(call, result)
                    "stopListening" -> stopLocalSpeech(result)
                    "cancelListening" -> cancelLocalSpeech(result)
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, focusSilenceChannelName)
            .setMethodCallHandler { call, result ->
                val focusSilence = FocusSilenceNative(applicationContext)
                try {
                    when (call.method) {
                        "getCapability" -> result.success(focusSilence.capability())
                        "openPolicyAccessSettings" -> {
                            focusSilence.openPolicyAccessSettings()
                            result.success(null)
                        }
                        "setActive" -> result.success(
                            focusSilence.setActive(
                                active = call.argument<Boolean>("active") == true,
                                profile = call.argument<String>("profile") ?: "alarmsOnly",
                                endsAtEpochMillis = call.argument<Number>("endsAtEpochMillis")?.toLong(),
                            ),
                        )
                        else -> result.notImplemented()
                    }
                } catch (error: Exception) {
                    result.error(
                        "focus_silence_failed",
                        error.message ?: "No se pudo cambiar No molestar.",
                        null,
                    )
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, screenAwakeChannelName)
            .setMethodCallHandler { call, result ->
                if (call.method != "setEnabled") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                if (call.argument<Boolean>("enabled") == true) {
                    window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                } else {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                }
                result.success(null)
            }
    }

    private fun startLocalSpeech(call: MethodCall, result: MethodChannel.Result) {
        if (!SpeechRecognizer.isRecognitionAvailable(applicationContext)) {
            result.error("local_speech_unavailable", "El reconocimiento local no está disponible.", null)
            return
        }
        val localeId = localSpeechLocale(call)
        localSpeechRecognizer?.destroy()
        val recognizer = createConfiguredLocalSpeechRecognizer()
        localSpeechRecognizer = recognizer
        recognizer.setRecognitionListener(
            object : RecognitionListener {
                override fun onReadyForSpeech(params: Bundle?) {
                    sendLocalSpeechEvent("speechStatus", "listening")
                }

                override fun onBeginningOfSpeech() = Unit

                override fun onRmsChanged(rmsdB: Float) = Unit

                override fun onBufferReceived(buffer: ByteArray?) = Unit

                override fun onEndOfSpeech() = Unit

                override fun onError(error: Int) {
                    sendLocalSpeechEvent("speechError", localSpeechError(error))
                    finishLocalSpeech()
                }

                override fun onResults(results: Bundle?) {
                    sendLocalSpeechResult(results, true)
                    finishLocalSpeech()
                }

                override fun onPartialResults(partialResults: Bundle?) {
                    sendLocalSpeechResult(partialResults, false)
                }

                override fun onEvent(eventType: Int, params: Bundle?) = Unit
            },
        )
        val intent = localSpeechIntent(localeId)
        recognizer.startListening(intent)
        Log.i("MichiFocusSpeech", "Configured local recognizer started for $localeId")
        result.success(true)
    }

    private fun stopLocalSpeech(result: MethodChannel.Result) {
        localSpeechRecognizer?.stopListening()
        result.success(true)
    }

    private fun cancelLocalSpeech(result: MethodChannel.Result) {
        localSpeechRecognizer?.cancel()
        finishLocalSpeech()
        result.success(true)
    }

    private fun finishLocalSpeech() {
        localSpeechRecognizer?.destroy()
        localSpeechRecognizer = null
        sendLocalSpeechEvent("speechStatus", "done")
    }

    private fun sendLocalSpeechResult(bundle: Bundle?, isFinal: Boolean) {
        val text = bundle
            ?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
            ?.firstOrNull()
            .orEmpty()
        if (text.isNotBlank()) {
            sendLocalSpeechEvent(
                "speechResult",
                mapOf("text" to text, "final" to isFinal),
            )
        }
    }

    private fun sendLocalSpeechEvent(method: String, value: Any) {
        Handler(Looper.getMainLooper()).post {
            localSpeechChannel.invokeMethod(method, value)
        }
    }

    private fun localSpeechError(error: Int): String = when (error) {
        SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -> "error_permission"
        SpeechRecognizer.ERROR_NO_MATCH -> "error_no_match"
        SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> "error_speech_timeout"
        SpeechRecognizer.ERROR_RECOGNIZER_BUSY -> "error_busy"
        SpeechRecognizer.ERROR_LANGUAGE_NOT_SUPPORTED -> "error_language_not_supported"
        SpeechRecognizer.ERROR_LANGUAGE_UNAVAILABLE -> "error_language_unavailable"
        else -> "error_unknown"
    }

    private fun localSpeechLocale(call: MethodCall): String =
        call.argument<String>("localeId")
            ?.trim()
            ?.replace('_', '-')
            ?.ifBlank { "es-ES" }
            ?: "es-ES"

    private fun localSpeechIntent(localeId: String): Intent =
        Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(
                RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM,
            )
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, localeId)
            putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
            putExtra(RecognizerIntent.EXTRA_PREFER_OFFLINE, true)
            putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 1)
            putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_COMPLETE_SILENCE_LENGTH_MILLIS, 60_000)
            putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_POSSIBLY_COMPLETE_SILENCE_LENGTH_MILLIS, 60_000)
        }

    private fun createConfiguredLocalSpeechRecognizer(): SpeechRecognizer {
        val configuredService = Settings.Secure.getString(
            contentResolver,
            "voice_recognition_service",
        )
        val component = configuredService
            ?.takeIf { it.isNotBlank() }
            ?.let(ComponentName::unflattenFromString)
        Log.i(
            "MichiFocusSpeech",
            "Using configured recognition service: ${component ?: "system default"}",
        )
        return if (component == null) {
            SpeechRecognizer.createSpeechRecognizer(applicationContext)
        } else {
            SpeechRecognizer.createSpeechRecognizer(applicationContext, component)
        }
    }

    private fun downloadLocalSpeechModel(call: MethodCall, result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            result.error(
                "local_speech_unsupported",
                "Android no admite la descarga local desde esta aplicación.",
                null,
            )
            return
        }
        val localeId = localSpeechLocale(call)
        if (localSpeechDownloadActive) {
            result.success("downloading")
            return
        }
        Log.i("MichiFocusSpeech", "Preparing local model for $localeId")
        val recognizer = createConfiguredLocalSpeechRecognizer()
        localSpeechDownloadRecognizer = recognizer
        localSpeechDownloadActive = true
        val intent = localSpeechIntent(localeId)
        if (Build.VERSION.SDK_INT == Build.VERSION_CODES.TIRAMISU) {
            recognizer.checkRecognitionSupport(
                intent,
                mainExecutor,
                object : RecognitionSupportCallback {
                    override fun onSupportResult(support: RecognitionSupport) {
                        when {
                            supportsLocale(support.installedOnDeviceLanguages, localeId) -> {
                                sendLocalSpeechEvent(
                                    "modelState",
                                    mapOf("phase" to "ready", "progress" to 100),
                                )
                                finishLocalSpeechDownload()
                                result.success("downloaded")
                            }
                            supportsLocale(support.pendingOnDeviceLanguages, localeId) -> {
                                sendScheduledModelState()
                                finishLocalSpeechDownload()
                                result.success("scheduled")
                            }
                            else -> triggerLegacyModelDownload(
                                recognizer,
                                intent,
                                localeId,
                                result,
                            )
                        }
                    }

                    override fun onError(error: Int) {
                        triggerLegacyModelDownload(
                            recognizer,
                            intent,
                            localeId,
                            result,
                        )
                    }
                },
            )
            return
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            recognizer.triggerModelDownload(
                intent,
                mainExecutor,
                object : ModelDownloadListener {
                    override fun onProgress(completedPercent: Int) {
                        sendLocalSpeechEvent(
                            "modelState",
                            mapOf("phase" to "downloading", "progress" to completedPercent),
                        )
                    }

                    override fun onSuccess() {
                        Log.i("MichiFocusSpeech", "Local model status: downloaded ($localeId)")
                        sendLocalSpeechEvent(
                            "modelState",
                            mapOf("phase" to "ready", "progress" to 100),
                        )
                        finishLocalSpeechDownload()
                    }

                    override fun onScheduled() {
                        sendScheduledModelState()
                        finishLocalSpeechDownload()
                    }

                    override fun onError(error: Int) {
                        Log.e(
                            "MichiFocusSpeech",
                            "Local model failed: $error ($localeId)",
                        )
                        sendLocalSpeechEvent(
                            "modelState",
                            mapOf("phase" to "failed", "error" to error),
                        )
                        finishLocalSpeechDownload()
                    }
                },
            )
            result.success("started")
        }
    }

    @Suppress("DEPRECATION")
    private fun triggerLegacyModelDownload(
        recognizer: SpeechRecognizer,
        intent: Intent,
        localeId: String,
        result: MethodChannel.Result,
    ) {
        try {
            recognizer.triggerModelDownload(intent)
            Log.i("MichiFocusSpeech", "Local model scheduled ($localeId)")
            sendScheduledModelState()
            result.success("scheduled")
        } catch (error: Exception) {
            Log.e("MichiFocusSpeech", "Could not schedule local model ($localeId)", error)
            sendLocalSpeechEvent(
                "modelState",
                mapOf("phase" to "failed"),
            )
            result.error(
                "local_speech_download_failed",
                error.message ?: "Android no pudo programar el idioma.",
                null,
            )
        } finally {
            finishLocalSpeechDownload()
        }
    }

    private fun sendScheduledModelState() {
        sendLocalSpeechEvent(
            "modelState",
            mapOf("phase" to "scheduled", "requiresManualAction" to true),
        )
    }

    private fun supportsLocale(locales: List<String>, localeId: String): Boolean {
        val target = localeId.replace('_', '-').lowercase()
        return locales.any {
            val candidate = it.replace('_', '-').lowercase()
            candidate == target ||
                (!candidate.contains('-') && target.startsWith("$candidate-"))
        }
    }

    private fun openLocalSpeechLanguageSettings(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        val localeId = localSpeechLocale(call)
        val configuredService = Settings.Secure.getString(
            contentResolver,
            "voice_recognition_service",
        )
        val servicePackage = configuredService
            ?.takeIf { it.isNotBlank() }
            ?.let(ComponentName::unflattenFromString)
            ?.packageName
        val languageManager = Intent(
            "com.google.recognition.action.DOWNLOAD_LANGUAGE",
        ).apply {
            if (servicePackage != null) {
                setPackage(servicePackage)
            }
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, localeId)
        }
        val fallback = Intent(Settings.ACTION_VOICE_INPUT_SETTINGS)
        val target = if (
            packageManager.resolveActivity(
                languageManager,
                PackageManager.MATCH_DEFAULT_ONLY,
            ) != null
        ) {
            languageManager
        } else {
            fallback
        }
        try {
            startActivity(target)
            result.success(true)
        } catch (error: ActivityNotFoundException) {
            result.error(
                "local_speech_settings_unavailable",
                "Android no ofrece una pantalla para administrar idiomas de voz.",
                null,
            )
        }
    }

    private fun finishLocalSpeechDownload() {
        localSpeechDownloadRecognizer?.destroy()
        localSpeechDownloadRecognizer = null
        localSpeechDownloadActive = false
    }

    private fun handleGroupKeystoreCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "isAvailable" -> result.success(isLocalAuthenticationAvailable())
                "hasKey" -> result.success(groupKeyStore().containsAlias(groupKeyAlias(call)))
                "wrap" -> wrapGroupDataKey(call, result)
                "unwrap" -> unwrapGroupDataKey(call, result)
                "delete" -> {
                    groupKeyStore().deleteEntry(groupKeyAlias(call))
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        } catch (_: UserNotAuthenticatedException) {
            result.error("authentication_required", "Se requiere autenticación del dispositivo.", null)
        } catch (_: KeyPermanentlyInvalidatedException) {
            result.error("key_invalidated", "La clave del dispositivo fue invalidada.", null)
        } catch (_: AEADBadTagException) {
            result.error("integrity_failed", "La envoltura local fue modificada.", null)
        } catch (error: Exception) {
            result.error("keystore_unavailable", error.message ?: "Android Keystore no está disponible.", null)
        }
    }

    private fun wrapGroupDataKey(call: MethodCall, result: MethodChannel.Result) {
        val groupId = requiredGroupId(call)
        val clearKey = requireNotNull(call.argument<ByteArray>("clearKey"))
        require(clearKey.size == 32) { "La clave de datos debe tener 32 bytes." }
        try {
            val cipher = Cipher.getInstance("AES/GCM/NoPadding")
            cipher.init(Cipher.ENCRYPT_MODE, getOrCreateGroupWrappingKey(groupId))
            cipher.updateAAD(groupKeyAssociatedData(groupId))
            val cipherText = cipher.doFinal(clearKey)
            result.success(mapOf("nonce" to cipher.iv, "cipherText" to cipherText))
        } finally {
            clearKey.fill(0)
        }
    }

    private fun unwrapGroupDataKey(call: MethodCall, result: MethodChannel.Result) {
        val groupId = requiredGroupId(call)
        val nonce = requireNotNull(call.argument<ByteArray>("nonce"))
        val cipherText = requireNotNull(call.argument<ByteArray>("cipherText"))
        require(nonce.size == 12) { "El nonce local debe tener 12 bytes." }
        require(cipherText.size == 48) { "La envoltura local debe tener 48 bytes." }
        val wrappingKey = groupKeyStore().getKey(groupKeyAlias(groupId), null) as? SecretKey
            ?: throw KeyPermanentlyInvalidatedException()
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.DECRYPT_MODE, wrappingKey, GCMParameterSpec(128, nonce))
        cipher.updateAAD(groupKeyAssociatedData(groupId))
        val clearKey = cipher.doFinal(cipherText)
        require(clearKey.size == 32) { "La clave local recuperada no es válida." }
        result.success(clearKey)
    }

    private fun getOrCreateGroupWrappingKey(groupId: String): SecretKey {
        val keyStore = groupKeyStore()
        val alias = groupKeyAlias(groupId)
        (keyStore.getKey(alias, null) as? SecretKey)?.let { return it }

        val builder = KeyGenParameterSpec.Builder(
            alias,
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
        )
            .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
            .setKeySize(256)
            .setRandomizedEncryptionRequired(true)
            .setUserAuthenticationRequired(true)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            builder.setUserAuthenticationParameters(
                300,
                KeyProperties.AUTH_BIOMETRIC_STRONG or KeyProperties.AUTH_DEVICE_CREDENTIAL,
            )
        } else {
            @Suppress("DEPRECATION")
            builder.setUserAuthenticationValidityDurationSeconds(300)
        }

        val generator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
        generator.init(builder.build())
        return generator.generateKey()
    }

    private fun groupKeyStore(): KeyStore {
        return KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
    }

    private fun requiredGroupId(call: MethodCall): String {
        val groupId = requireNotNull(call.argument<String>("groupId")).trim()
        require(Regex("^group_[a-f0-9]{32}$").matches(groupId)) { "Identificador de grupo inválido." }
        return groupId
    }

    private fun groupKeyAlias(call: MethodCall): String = groupKeyAlias(requiredGroupId(call))

    private fun groupKeyAlias(groupId: String): String = "michifocus.sync.$groupId.v1"

    private fun groupKeyAssociatedData(groupId: String): ByteArray {
        return "michifocus|1|$groupId|device-cache".toByteArray(Charsets.UTF_8)
    }

    private fun suggestedDeviceName(): String {
        val manufacturer = Build.MANUFACTURER.trim()
        val model = Build.MODEL.trim()
        if (manufacturer.isEmpty()) return model.ifEmpty { "Teléfono Android" }
        if (model.isEmpty()) return manufacturer
        if (model.startsWith(manufacturer, ignoreCase = true)) return model
        val displayManufacturer = manufacturer.replaceFirstChar { character ->
            if (character.isLowerCase()) character.titlecase() else character.toString()
        }
        return "$displayManufacturer $model"
    }

    private fun isLocalAuthenticationAvailable(): Boolean {
        val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
        return keyguardManager.isDeviceSecure
    }

    private fun authenticateLocally(result: MethodChannel.Result) {
        if (pendingLocalAuthResult != null) {
            result.error("authentication_busy", "Ya hay una autenticacion en curso.", null)
            return
        }
        if (!isLocalAuthenticationAvailable()) {
            result.success(false)
            return
        }

        pendingLocalAuthResult = result
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            showBiometricOrCredentialPrompt()
        } else {
            showDeviceCredentialPrompt()
        }
    }

    private fun showBiometricOrCredentialPrompt() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            showDeviceCredentialPrompt()
            return
        }

        val builder = BiometricPrompt.Builder(this)
            .setTitle("Desbloquear MichiFocus")
            .setSubtitle("Usa la seguridad registrada en este dispositivo")

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            builder.setAllowedAuthenticators(
                BiometricManager.Authenticators.BIOMETRIC_STRONG or
                    BiometricManager.Authenticators.DEVICE_CREDENTIAL,
            )
        } else {
            @Suppress("DEPRECATION")
            builder.setDeviceCredentialAllowed(true)
        }

        localAuthCancellationSignal = CancellationSignal()
        builder.build().authenticate(
            localAuthCancellationSignal!!,
            mainExecutor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(
                    authenticationResult: BiometricPrompt.AuthenticationResult,
                ) {
                    completeLocalAuthentication(true)
                }

                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    completeLocalAuthentication(false)
                }
            },
        )
    }

    @Suppress("DEPRECATION")
    private fun showDeviceCredentialPrompt() {
        val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
        val intent = keyguardManager.createConfirmDeviceCredentialIntent(
            "Desbloquear MichiFocus",
            "Usa el PIN, patron o contrasena de este dispositivo.",
        )
        if (intent == null) {
            completeLocalAuthentication(false)
            return
        }
        startActivityForResult(intent, localCredentialRequest)
    }

    private fun completeLocalAuthentication(authenticated: Boolean) {
        val result = pendingLocalAuthResult ?: return
        pendingLocalAuthResult = null
        localAuthCancellationSignal = null
        result.success(authenticated)
    }

    private fun replaceRoutineReminders(call: MethodCall, result: MethodChannel.Result) {
        try {
            val preferences = getSharedPreferences("routine_reminders", Context.MODE_PRIVATE)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED &&
                !preferences.getBoolean("notification_permission_requested", false)) {
                preferences.edit().putBoolean("notification_permission_requested", true).apply()
                requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 4104)
            }
            val reminders = call.argument<List<Map<String, Any>>>("reminders") ?: emptyList()
            RoutineReminderSchedulerNative.replace(this, reminders)
            result.success(routineReminderStatus())
        } catch (error: Exception) {
            result.error("routine_reminder_failed", error.message, null)
        }
    }

    private fun routineReminderStatus(): Map<String, Boolean> {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val notificationPermissionGranted =
            (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU ||
                checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED) &&
                (Build.VERSION.SDK_INT < Build.VERSION_CODES.N || notificationManager.areNotificationsEnabled())
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val exactSchedulingAvailable =
            Build.VERSION.SDK_INT < Build.VERSION_CODES.S || alarmManager.canScheduleExactAlarms()
        return mapOf(
            "notificationPermissionGranted" to notificationPermissionGranted,
            "exactSchedulingAvailable" to exactSchedulingAvailable,
        )
    }

    private fun openRoutineReminderSettings(result: MethodChannel.Result) {
        try {
            startActivity(
                Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).apply {
                    putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                },
            )
            result.success(null)
        } catch (error: Exception) {
            result.error("routine_reminder_settings_failed", error.message, null)
        }
    }

    private fun handleNativeFileCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "pickProfileImage" -> launchSingleResultIntent(
                result,
                pickProfileImageRequest,
                Intent.createChooser(
                    Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                        addCategory(Intent.CATEGORY_OPENABLE)
                        type = "image/*"
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        putExtra(Intent.EXTRA_MIME_TYPES, arrayOf("image/jpeg", "image/png", "image/webp", "image/gif"))
                    },
                    "Seleccionar foto",
                ),
            )
            "pickFolder" -> launchSingleResultIntent(
                result,
                pickFolderRequest,
                Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                    addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
                    addFlags(Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
                },
            )
            "pickBackupImportFolder" -> launchSingleResultIntent(
                result,
                pickBackupImportFolderRequest,
                Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
                    addFlags(Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
                },
            )
            "saveFileToExternalFolder" -> saveFileToExternalFolder(call, result)
            "validateSyncFolder" -> validateSyncFolder(call, result)
            "publishSyncGroupManifest" -> publishSyncGroupManifest(call, result)
            "publishSyncRecoverySnapshot" -> publishSyncRecoverySnapshot(call, result)
            "publishSyncOperation" -> publishSyncOperation(call, result)
            "discoverSyncOperations" -> discoverSyncOperations(call, result)
            "discoverSyncGroupManifests" -> discoverSyncGroupManifests(call, result)
            "openSyncthing" -> openSyncthing(result)
            "exportBackupToExternalFolder" -> exportBackupToExternalFolder(call, result)
            "openFile" -> openFile(call, result)
            "playCompletionSound" -> playCompletionSound(call, result)
            "playCompletionVibration" -> playCompletionVibration(call, result)
            else -> result.notImplemented()
        }
    }

    private fun openSyncthing(result: MethodChannel.Result) {
        val supportedPackages = listOf(
            "com.github.catfriend1.syncthingandroid",
            "com.nutomic.syncthingandroid",
        )
        try {
            for (supportedPackage in supportedPackages) {
                val launchIntent = packageManager.getLaunchIntentForPackage(supportedPackage)
                if (launchIntent != null) {
                    startActivity(launchIntent)
                    result.success(true)
                    return
                }
            }
            result.success(false)
        } catch (_: ActivityNotFoundException) {
            result.success(false)
        } catch (error: Exception) {
            result.error("syncthing_launch_failed", error.message, null)
        }
    }

    private fun launchSingleResultIntent(
        result: MethodChannel.Result,
        requestCode: Int,
        intent: Intent,
    ) {
        if (pendingResult != null) {
            result.error("picker_busy", "Ya hay un selector abierto.", null)
            return
        }

        pendingResult = result
        pendingRequestCode = requestCode
        startActivityForResult(intent, requestCode)
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == localCredentialRequest) {
            completeLocalAuthentication(resultCode == Activity.RESULT_OK)
            return
        }
        val result = pendingResult ?: return
        if (requestCode != pendingRequestCode) {
            return
        }

        pendingResult = null
        pendingRequestCode = null

        if (resultCode != Activity.RESULT_OK || data?.data == null) {
            result.success(null)
            return
        }

        val uri = data.data ?: run {
            result.success(null)
            return
        }

        try {
            when (requestCode) {
                pickProfileImageRequest -> result.success(copyProfileImage(uri))
                pickFolderRequest -> {
                    persistUriPermission(uri, data.flags)
                    result.success(mapOf("uri" to uri.toString(), "label" to folderLabel(uri)))
                }
                pickBackupImportFolderRequest -> {
                    persistUriPermission(uri, data.flags)
                    result.success(copyBackupImportFolder(uri))
                }
            }
        } catch (error: Exception) {
            result.error("native_file_error", error.message ?: "No se pudo completar la seleccion.", null)
        }
    }

    private fun persistUriPermission(uri: Uri, flags: Int) {
        val takeFlags = flags and (
            Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            )
        if (takeFlags != 0) {
            contentResolver.takePersistableUriPermission(uri, takeFlags)
        }
    }

    private fun copyProfileImage(uri: Uri): String {
        val extension = when (contentResolver.getType(uri)) {
            "image/png" -> ".png"
            "image/webp" -> ".webp"
            "image/gif" -> ".gif"
            else -> ".jpg"
        }
        val directory = File(filesDir, "profile")
        directory.mkdirs()
        val target = File(directory, "profile-image-${System.currentTimeMillis()}$extension")
        contentResolver.openInputStream(uri).use { input ->
            requireNotNull(input) { "No se pudo leer la imagen seleccionada." }
            target.outputStream().use { output -> input.copyTo(output) }
        }
        return target.absolutePath
    }

    private fun saveFileToExternalFolder(call: MethodCall, result: MethodChannel.Result) {
        try {
            val folderUri = Uri.parse(call.argument<String>("folderUri"))
            val fileName = requireNotNull(call.argument<String>("fileName"))
            val mimeType = requireNotNull(call.argument<String>("mimeType"))
            val bytes = requireNotNull(call.argument<ByteArray>("bytes"))
            val target = writeBytesToTree(folderUri, fileName, mimeType, bytes)
            result.success(
                mapOf(
                    "path" to "${folderLabel(folderUri)}/${target.displayName}",
                    "uri" to target.uri.toString(),
                ),
            )
        } catch (error: Exception) {
            result.error("external_save_failed", error.message ?: "No se pudo guardar el archivo.", null)
        }
    }

    private fun validateSyncFolder(call: MethodCall, result: MethodChannel.Result) {
        var probeUri: Uri? = null
        try {
            val folderUri = Uri.parse(requireNotNull(call.argument<String>("folderUri")))
            val probeBytes = "michifocus-folder-check-v1".toByteArray(Charsets.UTF_8)
            val probe = writeBytesToTree(
                folderUri,
                ".michifocus-check-${UUID.randomUUID()}.tmp",
                "application/octet-stream",
                probeBytes,
            )
            probeUri = probe.uri
            val readBytes = contentResolver.openInputStream(probe.uri).use { input ->
                requireNotNull(input) { "No se pudo leer el archivo de comprobación." }
                input.readBytes()
            }
            check(readBytes.contentEquals(probeBytes)) {
                "La carpeta cambió el archivo de comprobación."
            }
            check(DocumentsContract.deleteDocument(contentResolver, probe.uri)) {
                "No se pudo retirar el archivo de comprobación."
            }
            probeUri = null
            result.success(true)
        } catch (_: Exception) {
            probeUri?.let { uri ->
                try {
                    DocumentsContract.deleteDocument(contentResolver, uri)
                } catch (_: Exception) {
                    // Best effort: never hide the original validation failure.
                }
            }
            result.success(false)
        }
    }

    private fun publishSyncGroupManifest(call: MethodCall, result: MethodChannel.Result) {
        var temporaryUri: Uri? = null
        var createdFinalUri: Uri? = null
        try {
            val folderUri = Uri.parse(requireNotNull(call.argument<String>("folderUri")))
            val groupId = requireNotNull(call.argument<String>("groupId")).trim()
            require(Regex("^group_[a-f0-9]{32}$").matches(groupId)) {
                "El identificador del grupo no es válido."
            }
            val bytes = requireNotNull(call.argument<ByteArray>("bytes"))
            require(bytes.isNotEmpty() && bytes.size <= 64 * 1024) {
                "El manifiesto del grupo no tiene un tamaño válido."
            }
            val finalName = "michifocus-$groupId.v1.json"
            val relativePath = finalName

            findChild(folderUri, finalName)?.let { existing ->
                if (!readDocumentBytes(existing.uri).contentEquals(bytes)) {
                    throw GroupManifestConflictException()
                }
                result.success(
                    mapOf(
                        "relativePath" to relativePath,
                        "atomicFinalization" to true,
                    ),
                )
                return
            }

            val temporary = writeBytesToTree(
                folderUri,
                ".michifocus-$groupId-${UUID.randomUUID()}.tmp",
                "application/octet-stream",
                bytes,
            )
            temporaryUri = temporary.uri
            check(readDocumentBytes(temporary.uri).contentEquals(bytes)) {
                "La carpeta cambió el manifiesto temporal."
            }

            val renamedUri = try {
                DocumentsContract.renameDocument(contentResolver, temporary.uri, finalName)
            } catch (_: Exception) {
                null
            }
            if (renamedUri != null) {
                temporaryUri = null
                check(readDocumentBytes(renamedUri).contentEquals(bytes)) {
                    "La carpeta cambió el manifiesto final."
                }
                result.success(
                    mapOf(
                        "relativePath" to relativePath,
                        "atomicFinalization" to true,
                    ),
                )
                return
            }

            findChild(folderUri, finalName)?.let { existing ->
                if (!readDocumentBytes(existing.uri).contentEquals(bytes)) {
                    throw GroupManifestConflictException()
                }
                DocumentsContract.deleteDocument(contentResolver, temporary.uri)
                temporaryUri = null
                result.success(
                    mapOf(
                        "relativePath" to relativePath,
                        "atomicFinalization" to false,
                    ),
                )
                return
            }

            val parentUri = documentUriForTree(folderUri)
            val finalUri = DocumentsContract.createDocument(
                contentResolver,
                parentUri,
                "application/json",
                finalName,
            ) ?: throw IllegalStateException("No se pudo crear el manifiesto final.")
            createdFinalUri = finalUri
            contentResolver.openOutputStream(finalUri, "w").use { output ->
                requireNotNull(output) { "No se pudo escribir el manifiesto final." }
                output.write(bytes)
            }
            check(readDocumentBytes(finalUri).contentEquals(bytes)) {
                "La carpeta cambió el manifiesto final."
            }
            DocumentsContract.deleteDocument(contentResolver, temporary.uri)
            temporaryUri = null
            createdFinalUri = null
            result.success(
                mapOf(
                    "relativePath" to relativePath,
                    "atomicFinalization" to false,
                ),
            )
        } catch (_: GroupManifestConflictException) {
            cleanupDocument(temporaryUri)
            cleanupDocument(createdFinalUri)
            result.error(
                "group_manifest_conflict",
                "La carpeta contiene un manifiesto diferente para este grupo.",
                null,
            )
        } catch (error: Exception) {
            cleanupDocument(temporaryUri)
            cleanupDocument(createdFinalUri)
            result.error(
                "group_manifest_publish_failed",
                error.message ?: "No se pudo publicar el manifiesto del grupo.",
                null,
            )
        }
    }

    private fun readDocumentBytes(uri: Uri): ByteArray {
        return contentResolver.openInputStream(uri).use { input ->
            requireNotNull(input) { "No se pudo leer el documento." }
            input.readBytes()
        }
    }

    private fun publishSyncOperation(call: MethodCall, result: MethodChannel.Result) {
        var temporaryUri: Uri? = null
        var createdFinalUri: Uri? = null
        try {
            val folderUri = Uri.parse(requireNotNull(call.argument<String>("folderUri")))
            val groupId = requireNotNull(call.argument<String>("groupId")).trim()
            val installationId = requireNotNull(call.argument<String>("installationId")).trim()
            val operationId = requireNotNull(call.argument<String>("operationId")).trim()
            val originCounter = requireNotNull(call.argument<Number>("originCounter")).toLong()
            val bytes = requireNotNull(call.argument<ByteArray>("bytes"))
            require(Regex("^group_[a-f0-9]{32}$").matches(groupId))
            require(Regex("^installation_[a-f0-9]{32}$").matches(installationId))
            require(Regex("^operation_[a-f0-9]{32}$").matches(operationId))
            require(originCounter in 1..Long.MAX_VALUE)
            require(bytes.isNotEmpty() && bytes.size <= 384 * 1024)

            val counter = originCounter.toString().padStart(20, '0')
            val finalName = "michifocus-op-${installationId.removePrefix("installation_")}-" +
                "$counter-${operationId.removePrefix("operation_")}.v1.json"
            val relativePath = finalName

            findChild(folderUri, finalName)?.let { existing ->
                if (!readDocumentBytes(existing.uri).contentEquals(bytes)) {
                    throw GroupManifestConflictException()
                }
                result.success(
                    mapOf("relativePath" to relativePath, "atomicFinalization" to true),
                )
                return
            }

            val temporary = createTreeDocument(
                folderUri,
                ".michifocus-$operationId-${UUID.randomUUID()}.tmp",
                "application/octet-stream",
            )
            temporaryUri = temporary
            writeDocumentBytes(temporary, bytes)
            check(readDocumentBytes(temporary).contentEquals(bytes)) {
                "La carpeta cambió la operación temporal."
            }

            val renamedUri = try {
                DocumentsContract.renameDocument(contentResolver, temporary, finalName)
            } catch (_: Exception) {
                null
            }
            if (renamedUri != null) {
                temporaryUri = null
                check(readDocumentBytes(renamedUri).contentEquals(bytes)) {
                    "La carpeta cambió la operación final."
                }
                result.success(
                    mapOf("relativePath" to relativePath, "atomicFinalization" to true),
                )
                return
            }

            findChild(folderUri, finalName)?.let { existing ->
                if (!readDocumentBytes(existing.uri).contentEquals(bytes)) {
                    throw GroupManifestConflictException()
                }
                DocumentsContract.deleteDocument(contentResolver, temporary)
                temporaryUri = null
                result.success(
                    mapOf("relativePath" to relativePath, "atomicFinalization" to false),
                )
                return
            }

            val finalUri = createTreeDocument(folderUri, finalName, "application/json")
            createdFinalUri = finalUri
            writeDocumentBytes(finalUri, bytes)
            check(readDocumentBytes(finalUri).contentEquals(bytes)) {
                "La carpeta cambió la operación final."
            }
            DocumentsContract.deleteDocument(contentResolver, temporary)
            temporaryUri = null
            createdFinalUri = null
            result.success(
                mapOf("relativePath" to relativePath, "atomicFinalization" to false),
            )
        } catch (_: GroupManifestConflictException) {
            cleanupDocument(temporaryUri)
            cleanupDocument(createdFinalUri)
            result.error(
                "sync_operation_conflict",
                "Ya existe otra operación con ese identificador o contador.",
                null,
            )
        } catch (error: Exception) {
            Log.e("MichiFocusSync", "No se pudo publicar la operación cifrada.", error)
            cleanupDocument(temporaryUri)
            cleanupDocument(createdFinalUri)
            result.error(
                "sync_operation_publish_failed",
                error.message ?: "No se pudo publicar la operación cifrada.",
                null,
            )
        }
    }

    private fun discoverSyncOperations(call: MethodCall, result: MethodChannel.Result) {
        try {
            val folderUri = Uri.parse(requireNotNull(call.argument<String>("folderUri")))
            val localInstallationId =
                requireNotNull(call.argument<String>("localInstallationId")).trim()
            val installationPattern = Regex("^installation_[a-f0-9]{32}$")
            val filePattern = Regex(
                "^michifocus-op-([a-f0-9]{32})-(\\d{20})-" +
                    "([a-f0-9]{32})\\.v1\\.json$",
            )
            require(installationPattern.matches(localInstallationId))

            val discovered = mutableListOf<Map<String, Any>>()
            var visited = 0
            for (document in childDocuments(folderUri)) {
                val match = filePattern.matchEntire(document.displayName) ?: continue
                if ("installation_${match.groupValues[1]}" == localInstallationId) continue
                if (++visited > 4096) {
                    throw IllegalStateException("Hay demasiados archivos de sincronización.")
                }
                val bytes = readDocumentBytesLimited(document.uri, 384 * 1024)
                discovered.add(
                    mapOf(
                        "relativePath" to document.displayName,
                        "bytes" to bytes,
                    ),
                )
            }
            result.success(discovered)
        } catch (error: Exception) {
            result.error(
                "sync_operation_discovery_failed",
                error.message ?: "No se pudieron revisar los cambios recibidos.",
                null,
            )
        }
    }

    private fun getOrCreateDirectoryUnder(parentUri: Uri, name: String): Uri {
        findChildUnder(parentUri, name)?.let { return it.uri }
        return DocumentsContract.createDocument(
            contentResolver,
            parentUri,
            DocumentsContract.Document.MIME_TYPE_DIR,
            name,
        ) ?: throw IllegalStateException("No se pudo crear la carpeta $name.")
    }

    private fun createDocumentUnder(parentUri: Uri, name: String, mimeType: String): Uri {
        return DocumentsContract.createDocument(
            contentResolver,
            parentUri,
            mimeType,
            name,
        ) ?: throw IllegalStateException("No se pudo crear el documento $name.")
    }

    private fun writeDocumentBytes(uri: Uri, bytes: ByteArray) {
        contentResolver.openOutputStream(uri, "w").use { output ->
            requireNotNull(output) { "No se pudo escribir el documento." }
            output.write(bytes)
        }
    }

    private fun findChildUnder(parentUri: Uri, displayName: String): DocumentEntry? {
        val parentId = DocumentsContract.getDocumentId(parentUri)
        val childrenUri = DocumentsContract.buildChildDocumentsUriUsingTree(parentUri, parentId)
        contentResolver.query(
            childrenUri,
            arrayOf(
                DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            ),
            null,
            null,
            null,
        )?.use { cursor ->
            val idIndex = cursor.getColumnIndexOrThrow(
                DocumentsContract.Document.COLUMN_DOCUMENT_ID,
            )
            val nameIndex = cursor.getColumnIndexOrThrow(
                DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            )
            while (cursor.moveToNext()) {
                if (cursor.getString(nameIndex) == displayName) {
                    return DocumentEntry(
                        DocumentsContract.buildDocumentUriUsingTree(
                            parentUri,
                            cursor.getString(idIndex),
                        ),
                        displayName,
                    )
                }
            }
        }
        return null
    }

    private fun childDocumentsUnder(parentUri: Uri): List<DocumentEntry> {
        val parentId = DocumentsContract.getDocumentId(parentUri)
        val childrenUri = DocumentsContract.buildChildDocumentsUriUsingTree(parentUri, parentId)
        val entries = mutableListOf<DocumentEntry>()
        contentResolver.query(
            childrenUri,
            arrayOf(
                DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            ),
            null,
            null,
            null,
        )?.use { cursor ->
            val idIndex = cursor.getColumnIndexOrThrow(
                DocumentsContract.Document.COLUMN_DOCUMENT_ID,
            )
            val nameIndex = cursor.getColumnIndexOrThrow(
                DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            )
            while (cursor.moveToNext()) {
                entries.add(
                    DocumentEntry(
                        DocumentsContract.buildDocumentUriUsingTree(
                            parentUri,
                            cursor.getString(idIndex),
                        ),
                        cursor.getString(nameIndex),
                    ),
                )
            }
        }
        return entries
    }

    private fun publishSyncRecoverySnapshot(call: MethodCall, result: MethodChannel.Result) {
        var temporaryUri: Uri? = null
        var createdFinalUri: Uri? = null
        try {
            val folderUri = Uri.parse(requireNotNull(call.argument<String>("folderUri")))
            val groupId = requireNotNull(call.argument<String>("groupId")).trim()
            val snapshotId = requireNotNull(call.argument<String>("snapshotId")).trim()
            require(Regex("^group_[a-f0-9]{32}$").matches(groupId))
            require(Regex("^snapshot_[a-f0-9]{32}$").matches(snapshotId))
            val source = File(requireNotNull(call.argument<String>("sourcePath"))).canonicalFile
            val cacheBoundary = cacheDir.canonicalFile
            require(source.path.startsWith(cacheBoundary.path + File.separator)) {
                "La instantánea temporal no pertenece a MichiFocus."
            }
            require(source.isFile && source.length() > 0L) {
                "La instantánea cifrada no está disponible."
            }

            val expectedDigest = digest(source.inputStream())
            val finalName = "michifocus-$groupId-recovery-$snapshotId.v1.json"
            findChild(folderUri, finalName)?.let { existing ->
                if (!documentMatches(existing.uri, source.length(), expectedDigest)) {
                    throw GroupManifestConflictException()
                }
                result.success(
                    mapOf("relativePath" to finalName, "atomicFinalization" to true),
                )
                return
            }

            val temporaryName = ".michifocus-$snapshotId-${UUID.randomUUID()}.tmp"
            val temporary = createTreeDocument(
                folderUri,
                temporaryName,
                "application/octet-stream",
            )
            temporaryUri = temporary
            copyFileToDocument(source, temporary)
            check(documentMatches(temporary, source.length(), expectedDigest)) {
                "La carpeta cambió la instantánea temporal."
            }

            val renamedUri = try {
                DocumentsContract.renameDocument(contentResolver, temporary, finalName)
            } catch (_: Exception) {
                null
            }
            if (renamedUri != null) {
                temporaryUri = null
                check(documentMatches(renamedUri, source.length(), expectedDigest)) {
                    "La carpeta cambió la instantánea final."
                }
                result.success(
                    mapOf("relativePath" to finalName, "atomicFinalization" to true),
                )
                return
            }

            findChild(folderUri, finalName)?.let { existing ->
                if (!documentMatches(existing.uri, source.length(), expectedDigest)) {
                    throw GroupManifestConflictException()
                }
                DocumentsContract.deleteDocument(contentResolver, temporary)
                temporaryUri = null
                result.success(
                    mapOf("relativePath" to finalName, "atomicFinalization" to false),
                )
                return
            }

            val finalUri = createTreeDocument(folderUri, finalName, "application/json")
            createdFinalUri = finalUri
            copyFileToDocument(source, finalUri)
            check(documentMatches(finalUri, source.length(), expectedDigest)) {
                "La carpeta cambió la instantánea final."
            }
            DocumentsContract.deleteDocument(contentResolver, temporary)
            temporaryUri = null
            createdFinalUri = null
            result.success(
                mapOf("relativePath" to finalName, "atomicFinalization" to false),
            )
        } catch (_: GroupManifestConflictException) {
            cleanupDocument(temporaryUri)
            cleanupDocument(createdFinalUri)
            result.error(
                "recovery_snapshot_conflict",
                "Ya existe otra instantánea con ese identificador.",
                null,
            )
        } catch (error: Exception) {
            cleanupDocument(temporaryUri)
            cleanupDocument(createdFinalUri)
            result.error(
                "recovery_snapshot_publish_failed",
                error.message ?: "No se pudo guardar la instantánea.",
                null,
            )
        }
    }

    private fun createTreeDocument(folderUri: Uri, name: String, mimeType: String): Uri {
        return DocumentsContract.createDocument(
            contentResolver,
            documentUriForTree(folderUri),
            mimeType,
            name,
        ) ?: throw IllegalStateException("No se pudo crear el documento.")
    }

    private fun copyFileToDocument(source: File, target: Uri) {
        source.inputStream().use { input ->
            contentResolver.openOutputStream(target, "w").use { output ->
                requireNotNull(output) { "No se pudo escribir el documento." }
                input.copyTo(output)
            }
        }
    }

    private fun documentMatches(uri: Uri, expectedSize: Long, expectedDigest: ByteArray): Boolean {
        val size = contentResolver.query(
            uri,
            arrayOf(OpenableColumns.SIZE),
            null,
            null,
            null,
        ).use { cursor ->
            if (cursor == null || !cursor.moveToFirst() || cursor.isNull(0)) -1L
            else cursor.getLong(0)
        }
        return size == expectedSize && digestDocument(uri).contentEquals(expectedDigest)
    }

    private fun digestDocument(uri: Uri): ByteArray {
        return contentResolver.openInputStream(uri).use { input ->
            digest(requireNotNull(input) { "No se pudo leer la instantánea." })
        }
    }

    private fun digest(input: InputStream): ByteArray {
        val messageDigest = MessageDigest.getInstance("SHA-256")
        val buffer = ByteArray(32 * 1024)
        while (true) {
            val count = input.read(buffer)
            if (count < 0) break
            messageDigest.update(buffer, 0, count)
        }
        input.close()
        return messageDigest.digest()
    }

    private fun discoverSyncGroupManifests(call: MethodCall, result: MethodChannel.Result) {
        try {
            val folderUri = Uri.parse(requireNotNull(call.argument<String>("folderUri")))
            val finalNamePattern = Regex("^michifocus-group_[a-f0-9]{32}\\.v1\\.json$")
            val manifests = mutableListOf<Map<String, Any>>()
            for (document in childDocuments(folderUri)) {
                if (!finalNamePattern.matches(document.displayName)) continue
                try {
                    manifests.add(
                        mapOf(
                            "relativePath" to document.displayName,
                            "bytes" to readDocumentBytesLimited(document.uri, 64 * 1024),
                        ),
                    )
                } catch (_: Exception) {
                    manifests.add(
                        mapOf(
                            "relativePath" to document.displayName,
                            "bytes" to ByteArray(0),
                        ),
                    )
                }
            }
            result.success(manifests)
        } catch (error: Exception) {
            result.error(
                "group_manifest_discovery_failed",
                error.message ?: "No se pudieron revisar los grupos de la carpeta.",
                null,
            )
        }
    }

    private fun readDocumentBytesLimited(uri: Uri, maximumBytes: Int): ByteArray {
        return contentResolver.openInputStream(uri).use { input ->
            requireNotNull(input) { "No se pudo leer el documento." }
            val output = ByteArrayOutputStream()
            val buffer = ByteArray(8 * 1024)
            var total = 0
            while (true) {
                val count = input.read(buffer)
                if (count < 0) break
                total += count
                require(total <= maximumBytes) { "El documento supera el límite permitido." }
                output.write(buffer, 0, count)
            }
            output.toByteArray()
        }
    }

    private fun cleanupDocument(uri: Uri?) {
        if (uri == null) return
        try {
            DocumentsContract.deleteDocument(contentResolver, uri)
        } catch (_: Exception) {
            // Best effort cleanup. The original publication failure remains authoritative.
        }
    }

    private fun exportBackupToExternalFolder(call: MethodCall, result: MethodChannel.Result) {
        try {
            val folderUri = Uri.parse(call.argument<String>("folderUri"))
            val fileNames = call.argument<List<String>>("fileNames") ?: backupFileNames.toList()
            val backupDirectoryUri = getOrCreateChildDirectory(folderUri, "michifocus-backup")
            val exported = mutableListOf<String>()

            for (fileName in fileNames) {
                val source = backupSourceFile(fileName)
                if (!source.exists()) {
                    continue
                }
                val displayName = writeBytesToTree(
                    backupDirectoryUri,
                    fileName,
                    "application/octet-stream",
                    source.readBytes(),
                )
                exported.add(displayName.displayName)
            }

            if (exported.isEmpty()) {
                throw IllegalStateException("No hay archivos locales de backup para exportar.")
            }

            result.success("${folderLabel(folderUri)}/michifocus-backup")
        } catch (error: Exception) {
            result.error("external_backup_failed", error.message ?: "No se pudo exportar el backup.", null)
        }
    }

    private fun openFile(call: MethodCall, result: MethodChannel.Result) {
        try {
            val path = requireNotNull(call.argument<String>("path")).trim()
            val mimeType = call.argument<String>("mimeType") ?: "application/pdf"
            val uri = when {
                path.startsWith("content://") -> readableContentUri(path)
                Uri.parse(path).scheme == null -> cachedFileUri(path)
                else -> null
            } ?: throw IllegalStateException("No se encontro el archivo exportado.")

            val viewIntent = Intent(Intent.ACTION_VIEW).apply {
                setDataAndType(uri, mimeType)
                clipData = ClipData.newRawUri("Reporte MichiFocus", uri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            startActivity(Intent.createChooser(viewIntent, "Abrir reporte"))
            result.success(null)
        } catch (error: ActivityNotFoundException) {
            result.error(
                "viewer_unavailable",
                "No hay una aplicacion instalada para abrir archivos PDF.",
                null,
            )
        } catch (error: Exception) {
            result.error(
                "open_file_failed",
                error.message ?: "No se pudo abrir el archivo.",
                null,
            )
        }
    }

    private fun readableContentUri(path: String): Uri {
        val uri = Uri.parse(path)
        contentResolver.openFileDescriptor(uri, "r").use { descriptor ->
            requireNotNull(descriptor) { "No se pudo leer el archivo exportado." }
        }
        return uri
    }

    private fun cachedFileUri(path: String): Uri {
        val source = File(path)
        require(source.exists() && source.isFile && source.canRead()) {
            "No se encontro el archivo exportado."
        }
        val directory = File(cacheDir, "opened_reports")
        directory.mkdirs()
        val target = File(directory, source.name)
        source.copyTo(target, overwrite = true)
        return FileProvider.getUriForFile(
            this,
            "$packageName.file_provider",
            target,
        )
    }

    private fun playCompletionSound(call: MethodCall, result: MethodChannel.Result) {
        try {
            val sound = call.argument<String>("sound") ?: "softBell"
            if (sound == "silent") {
                result.success(null)
                return
            }
            if (playSoundResource(sound)) {
                result.success(null)
                return
            }

            if (playMelody(sound)) {
                result.success(null)
                return
            }

            val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            val ringtone = RingtoneManager.getRingtone(applicationContext, uri)
            ringtone.play()
            Handler(Looper.getMainLooper()).postDelayed({ ringtone.stop() }, 1400)
            result.success(null)
        } catch (error: Exception) {
            result.error("sound_failed", error.message ?: "No se pudo reproducir el tono.", null)
        }
    }

    @Suppress("DEPRECATION")
    private fun playCompletionVibration(call: MethodCall, result: MethodChannel.Result) {
        try {
            val pattern = call.argument<String>("pattern") ?: "normal"
            val (timings, amplitudes) = when (pattern) {
                "light" -> longArrayOf(0L, 90L) to intArrayOf(0, 90)
                "double" -> longArrayOf(0L, 150L, 110L, 190L) to
                    intArrayOf(0, 170, 0, 220)
                "intense" -> longArrayOf(0L, 450L, 120L, 320L) to
                    intArrayOf(0, 255, 0, 255)
                else -> longArrayOf(0L, 240L) to intArrayOf(0, 190)
            }
            val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                getSystemService(VibratorManager::class.java).defaultVibrator
            } else {
                getSystemService(VIBRATOR_SERVICE) as Vibrator
            }

            if (!vibrator.hasVibrator()) {
                result.success(false)
                return
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val effect = if (vibrator.hasAmplitudeControl()) {
                    VibrationEffect.createWaveform(timings, amplitudes, -1)
                } else {
                    VibrationEffect.createWaveform(timings, -1)
                }
                vibrator.vibrate(effect)
            } else {
                vibrator.vibrate(timings, -1)
            }
            result.success(true)
        } catch (error: Exception) {
            result.error(
                "vibration_failed",
                error.message ?: "No se pudo activar la vibracion.",
                null,
            )
        }
    }

    private fun playSoundResource(sound: String): Boolean {
        val resourceId = when (sound) {
            "lightTap" -> R.raw.light_tap
            "warmChime" -> R.raw.warm_chime
            "crystalChime" -> R.raw.crystal_chime
            "calmPulse" -> R.raw.calm_pulse
            "deepChime" -> R.raw.deep_chime
            "digitalZen" -> R.raw.digital_zen
            else -> R.raw.soft_bell
        }
        val player = MediaPlayer.create(applicationContext, resourceId) ?: return false
        player.setOnCompletionListener { completed -> completed.release() }
        player.setOnErrorListener { failed, _, _ ->
            failed.release()
            true
        }
        player.start()
        return true
    }

    private fun playMelody(sound: String): Boolean {
        val sequence = when (sound) {
            "lightTap" -> listOf(
                ToneGenerator.TONE_PROP_BEEP to 90L,
                ToneGenerator.TONE_PROP_ACK to 140L,
            )
            "deepChime" -> listOf(
                ToneGenerator.TONE_DTMF_6 to 120L,
                ToneGenerator.TONE_DTMF_9 to 150L,
                ToneGenerator.TONE_PROP_ACK to 220L,
            )
            "warmChime" -> listOf(
                ToneGenerator.TONE_DTMF_4 to 110L,
                ToneGenerator.TONE_DTMF_6 to 130L,
                ToneGenerator.TONE_PROP_ACK to 180L,
            )
            "crystalChime" -> listOf(
                ToneGenerator.TONE_DTMF_8 to 80L,
                ToneGenerator.TONE_DTMF_9 to 100L,
                ToneGenerator.TONE_PROP_ACK to 160L,
            )
            "calmPulse" -> listOf(
                ToneGenerator.TONE_DTMF_2 to 130L,
                ToneGenerator.TONE_DTMF_2 to 130L,
                ToneGenerator.TONE_PROP_PROMPT to 180L,
            )
            "digitalZen" -> listOf(
                ToneGenerator.TONE_DTMF_A to 80L,
                ToneGenerator.TONE_DTMF_B to 90L,
                ToneGenerator.TONE_DTMF_D to 140L,
            )
            "silent" -> return true
            else -> listOf(
                ToneGenerator.TONE_DTMF_5 to 110L,
                ToneGenerator.TONE_DTMF_8 to 130L,
                ToneGenerator.TONE_PROP_ACK to 210L,
            )
        }
        val toneGenerator = ToneGenerator(AudioManager.STREAM_NOTIFICATION, 72)
        val handler = Handler(Looper.getMainLooper())
        var delay = 0L
        for ((tone, duration) in sequence) {
            handler.postDelayed({ toneGenerator.startTone(tone, duration.toInt()) }, delay)
            delay += duration + 70L
        }
        handler.postDelayed({ toneGenerator.release() }, delay + 120L)
        return true
    }

    private fun copyBackupImportFolder(folderUri: Uri): String {
        val targetDirectory = File(cacheDir, "michifocus-native-import")
        if (targetDirectory.exists()) {
            targetDirectory.deleteRecursively()
        }
        targetDirectory.mkdirs()

        var copied = 0
        val acceptedFileNames = backupFileNames + legacyBackupFileNames
        for (document in childDocuments(folderUri)) {
            val name = document.displayName
            if (!acceptedFileNames.contains(name)) {
                continue
            }
            contentResolver.openInputStream(document.uri).use { input ->
                requireNotNull(input) { "No se pudo leer $name." }
                File(targetDirectory, name).outputStream().use { output -> input.copyTo(output) }
            }
            copied += 1
        }

        if (copied == 0) {
            throw IllegalStateException("La carpeta no contiene archivos de backup de MichiFocus.")
        }

        return targetDirectory.absolutePath
    }

    private fun writeBytesToTree(
        treeUri: Uri,
        displayName: String,
        mimeType: String,
        bytes: ByteArray,
    ): DocumentEntry {
        val parentUri = documentUriForTree(treeUri)
        findChild(treeUri, displayName)?.let { existing ->
            DocumentsContract.deleteDocument(contentResolver, existing.uri)
        }
        val targetUri = DocumentsContract.createDocument(
            contentResolver,
            parentUri,
            mimeType,
            displayName,
        ) ?: throw IllegalStateException("No se pudo crear $displayName.")

        contentResolver.openOutputStream(targetUri, "w").use { output ->
            requireNotNull(output) { "No se pudo escribir $displayName." }
            output.write(bytes)
        }

        return DocumentEntry(targetUri, displayName)
    }

    private fun getOrCreateChildDirectory(treeUri: Uri, name: String): Uri {
        findChild(treeUri, name)?.let { return it.uri }
        val parentUri = documentUriForTree(treeUri)
        return DocumentsContract.createDocument(
            contentResolver,
            parentUri,
            DocumentsContract.Document.MIME_TYPE_DIR,
            name,
        ) ?: throw IllegalStateException("No se pudo crear la carpeta $name.")
    }

    private fun findChild(treeUri: Uri, displayName: String): DocumentEntry? {
        return childDocuments(treeUri).firstOrNull { it.displayName == displayName }
    }

    private fun childDocuments(treeUri: Uri): List<DocumentEntry> {
        val childrenUri = DocumentsContract.buildChildDocumentsUriUsingTree(
            treeUri,
            DocumentsContract.getTreeDocumentId(treeUri),
        )
        val entries = mutableListOf<DocumentEntry>()
        contentResolver.query(
            childrenUri,
            arrayOf(
                DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            ),
            null,
            null,
            null,
        )?.use { cursor ->
            val idIndex = cursor.getColumnIndexOrThrow(DocumentsContract.Document.COLUMN_DOCUMENT_ID)
            val nameIndex = cursor.getColumnIndexOrThrow(DocumentsContract.Document.COLUMN_DISPLAY_NAME)
            while (cursor.moveToNext()) {
                val id = cursor.getString(idIndex)
                val name = cursor.getString(nameIndex)
                entries.add(
                    DocumentEntry(
                        uri = DocumentsContract.buildDocumentUriUsingTree(treeUri, id),
                        displayName = name,
                    ),
                )
            }
        }
        return entries
    }

    private fun documentUriForTree(treeUri: Uri): Uri {
        return DocumentsContract.buildDocumentUriUsingTree(
            treeUri,
            DocumentsContract.getTreeDocumentId(treeUri),
        )
    }

    private fun flutterDocumentsDirectory(): File {
        return File(applicationInfo.dataDir, "app_flutter")
    }

    private fun backupSourceFile(fileName: String): File {
        val flutterFile = File(flutterDocumentsDirectory(), fileName)
        if (flutterFile.exists()) {
            return flutterFile
        }

        return File(filesDir, fileName)
    }

    private fun folderLabel(uri: Uri): String {
        try {
            contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val index = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                    if (index >= 0) {
                        return cursor.getString(index)
                    }
                }
            }
        } catch (_: Exception) {
            // Some Android document providers do not support querying a tree Uri directly.
        }

        return try {
            val treeId = DocumentsContract.getTreeDocumentId(uri)
            treeId.substringAfter(':', treeId).ifBlank { "carpeta externa" }
        } catch (_: Exception) {
            uri.lastPathSegment?.substringAfter(':') ?: "carpeta externa"
        }
    }

    private data class DocumentEntry(
        val uri: Uri,
        val displayName: String,
    )

    private class GroupManifestConflictException : Exception()
}
