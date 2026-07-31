package com.example.pomodoro_app_v1

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.ClipData
import android.content.Intent
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.media.ToneGenerator
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.DocumentsContract
import android.provider.OpenableColumns
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "michifocus/native_files"
    private val pickProfileImageRequest = 4101
    private val pickFolderRequest = 4102
    private val pickBackupImportFolderRequest = 4103
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

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result -> handleNativeFileCall(call, result) }
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
            "exportBackupToExternalFolder" -> exportBackupToExternalFolder(call, result)
            "openFile" -> openFile(call, result)
            "playCompletionSound" -> playCompletionSound(call, result)
            else -> result.notImplemented()
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
}
