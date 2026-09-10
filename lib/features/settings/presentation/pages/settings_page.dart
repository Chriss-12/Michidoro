import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/di/service_locator.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/state/native_file_manager.dart';
import 'package:pomodoro_app_v1/app/state/routine_reminder_scheduler.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/features/focus_silence/presentation/controllers/focus_silence_controller.dart';
import 'package:pomodoro_app_v1/features/focus_silence/presentation/widgets/focus_silence_settings_card.dart';
import 'package:pomodoro_app_v1/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/widgets/routine_reminder_capability_tile.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/device_identity_scope.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/device_identity_settings_card.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/local_app_lock_scope.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/local_security_settings_card.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/sync_group_enrollment_scope.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/sync_group_enrollment_settings_card.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/sync_storage_scope.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/widgets/sync_storage_settings_card.dart';
import 'package:pomodoro_app_v1/l10n/app_language.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routePath = '/settings';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppCardPaddings.page,
      children: [
        const SizedBox(height: 24),
        const _ProfileCard(),
        const SizedBox(height: 26),
        const _AppearanceCard(),
        const SizedBox(height: 26),
        const _LanguageCard(),
        const SizedBox(height: 26),
        const _OnboardingPreviewCard(),
        const SizedBox(height: 26),
        const _FocusTimesCard(),
        const SizedBox(height: 26),
        const _ReportsCard(),
        const SizedBox(height: 26),
        const _NotificationsCard(),
        if (serviceLocator.isRegistered<FocusSilenceController>()) ...[
          const SizedBox(height: 26),
          FocusSilenceSettingsCard(
            controller: serviceLocator<FocusSilenceController>(),
          ),
        ],
        const SizedBox(height: 26),
        SyncStorageSettingsCard(controller: SyncStorageScope.of(context)),
        DeviceIdentitySettingsSection(
          identityController: DeviceIdentityScope.of(context),
          storageController: SyncStorageScope.of(context),
        ),
        SyncGroupEnrollmentSettingsCard(
          controller: SyncGroupEnrollmentScope.of(context),
          storageController: SyncStorageScope.of(context),
        ),
        const SizedBox(height: 26),
        LocalSecuritySettingsCard(controller: LocalAppLockScope.of(context)),
        const SizedBox(height: 26),
        const _TypographyPresetCard(),
        const SizedBox(height: 26),
        const _DatabaseDataCard(),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _DatabaseDataCard extends StatelessWidget {
  const _DatabaseDataCard();

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final colors = Theme.of(context).colorScheme;

    return GlassCard(
      key: const ValueKey('database-danger-zone'),
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.storage_rounded,
            title: context.tr('Datos de la aplicación', 'Application data'),
          ),
          const SizedBox(height: 12),
          Text(
            context.tr(
              'Borra objetivos, tareas, notas, sesiones, rutinas, calendario y estadísticas. Tus ajustes y archivos exportados se conservan.',
              'Deletes goals, tasks, sessions, routines, calendar data, and statistics. Settings and exported files are retained.',
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.palette.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: const ValueKey('delete-all-database-data'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.error,
                side: BorderSide(color: colors.error),
              ),
              onPressed: () => _confirmAndDelete(context, settings),
              icon: const Icon(Icons.delete_forever_rounded),
              label: Text(
                context.tr('Borrar todos los datos', 'Delete all data'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndDelete(
    BuildContext context,
    AppSettingsScope settings,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _DeleteDatabaseDataDialog(),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await settings.onDeleteAllDatabaseData();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr(
              'Todos los datos de la base de datos fueron borrados.',
              'All database data was deleted.',
            ),
          ),
        ),
      );
    } on Object {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr(
              'No se pudieron borrar los datos. Inténtalo de nuevo.',
              'The data could not be deleted. Try again.',
            ),
          ),
        ),
      );
    }
  }
}

class _DeleteDatabaseDataDialog extends StatefulWidget {
  const _DeleteDatabaseDataDialog();

  @override
  State<_DeleteDatabaseDataDialog> createState() =>
      _DeleteDatabaseDataDialogState();
}

class _DeleteDatabaseDataDialogState extends State<_DeleteDatabaseDataDialog> {
  late final TextEditingController _confirmationController;
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    _confirmationController = TextEditingController();
  }

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    final confirmation = isEnglish ? 'DELETE' : 'BORRAR';
    final colors = Theme.of(context).colorScheme;

    return AlertDialog(
      key: const ValueKey('delete-database-data-dialog'),
      icon: Icon(Icons.warning_amber_rounded, color: colors.error),
      title: Text(
        context.tr('¿Borrar todos los datos?', 'Delete all data?'),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr(
                'Esta acción es irreversible. Se eliminará toda la información guardada en la base de datos. El tema, idioma, perfil y archivos exportados no se borrarán.',
                'This action cannot be undone. All information stored in the database will be deleted. Theme, language, profile, and exported files will not be removed.',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.tr(
                'Para confirmar, escribe $confirmation.',
                'Type $confirmation to confirm.',
              ),
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const ValueKey('database-delete-confirmation-field'),
              controller: _confirmationController,
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: context.tr('Confirmación', 'Confirmation'),
                hintText: confirmation,
              ),
              onChanged: (value) {
                final matches = value.trim().toUpperCase() == confirmation;
                if (matches != _confirmed) {
                  setState(() => _confirmed = matches);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.tr('Cancelar', 'Cancel')),
        ),
        FilledButton.icon(
          key: const ValueKey('confirm-delete-database-data'),
          style: FilledButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.onError,
          ),
          onPressed: _confirmed ? () => Navigator.of(context).pop(true) : null,
          icon: const Icon(Icons.delete_forever_rounded),
          label: Text(
            context.tr('Borrar definitivamente', 'Delete permanently'),
          ),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatefulWidget {
  const _ProfileCard();

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  TextEditingController? _nameController;
  TextEditingController? _emailController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = AppSettingsScope.of(context);
    _nameController ??= TextEditingController(text: settings.profileName);
    _emailController ??= TextEditingController(text: settings.profileEmail);
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _emailController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettingsScope.of(context);
    final image = _profileImage(settings.profileImagePath);

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: palette.primaryMuted,
              foregroundImage: image,
              child: image == null
                  ? Text(
                      _avatarLabel(settings),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: palette.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 24),
            _FieldLabel(context.tr('Nombre de usuario', 'Username')),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 18),
            _FieldLabel(context.tr('Correo electrónico', 'Email')),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'tu-correo@ejemplo.com',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
            ),
            const SizedBox(height: 18),
            _FieldLabel(context.tr('Foto local', 'Local photo')),
            if (settings.profileImagePath.trim().isNotEmpty) ...[
              Text(
                settings.profileImagePath,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final path = await _selectProfileImage(
                        context,
                      );
                      if (path == null || !context.mounted) {
                        return;
                      }

                      settings.onProfileImagePathChanged(path);
                    },
                    icon: const Icon(Icons.image_search_rounded),
                    label: Text(
                      context.tr('Seleccionar foto', 'Select photo'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  tooltip: context.tr('Quitar foto', 'Remove photo'),
                  onPressed: settings.profileImagePath.trim().isEmpty
                      ? null
                      : () => settings.onProfileImagePathChanged(''),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  settings.onProfileNameChanged(_nameController?.text ?? '');
                  settings.onProfileEmailChanged(_emailController?.text ?? '');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.tr('Perfil actualizado.', 'Profile updated.'),
                      ),
                    ),
                  );
                },
                child: Text(context.tr('Guardar cambios', 'Save changes')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider? _profileImage(String path) {
    if (NativeFileManager.isExternalFolderReference(path)) {
      return null;
    }

    if (path.trim().isEmpty) {
      return null;
    }

    final file = File(path.trim());
    if (!file.existsSync()) {
      return null;
    }

    return FileImage(file);
  }

  String _avatarLabel(AppSettingsScope settings) {
    if (settings.profileName.trim().isNotEmpty) {
      return settings.profileName.trim().characters.first.toUpperCase();
    }

    return 'U';
  }

  Future<String?> _selectProfileImage(
    BuildContext context,
  ) async {
    try {
      final externalPath = await NativeFileManager.pickProfileImage();
      if (externalPath != null && externalPath.trim().isNotEmpty) {
        return externalPath;
      }
    } on PlatformException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.message ??
                  context.tr(
                    'No se pudo abrir la galería.',
                    'The gallery could not be opened.',
                  ),
            ),
          ),
        );
      }
    }

    return null;
  }
}

class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettingsScope.of(context);

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.palette_outlined,
            title: context.tr('Apariencia', 'Appearance'),
          ),
          const SizedBox(height: 18),
          _ModeTile(
            label: context.tr('Modo claro', 'Light mode'),
            value: !settings.isDarkMode,
            onChanged: (value) => settings.onDarkModeChanged(!value),
          ),
          const SizedBox(height: 14),
          _ModeTile(
            label: context.tr('Modo oscuro', 'Dark mode'),
            value: settings.isDarkMode,
            onChanged: settings.onDarkModeChanged,
          ),
          const SizedBox(height: 18),
          _TextScaleControl(settings: settings),
          const SizedBox(height: 18),
          Text(
            context.tr('Tema de color', 'Color theme'),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<AppThemePreset>(
            key: const ValueKey('settings-theme-selector'),
            value: settings.themePreset,
            isExpanded: true,
            menuMaxHeight: 360,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.palette_rounded),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
            items: [
              for (final preset in AppThemePreset.values)
                DropdownMenuItem(
                  key: ValueKey('settings-theme-option-${preset.name}'),
                  value: preset,
                  child: _ThemeSelectorOption(
                    preset: preset,
                    label: _themeLabel(context, preset),
                    isDark: settings.isDarkMode,
                  ),
                ),
            ],
            onChanged: (preset) {
              if (preset != null) {
                settings.onThemeChanged(preset);
              }
            },
          ),
          const SizedBox(height: 12),
          Text(
            context.tr(
              'Tema actual: ${_themeLabel(context, settings.themePreset)}',
              'Current theme: ${_themeLabel(context, settings.themePreset)}',
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _themeLabel(BuildContext context, AppThemePreset preset) {
    return switch (preset) {
      AppThemePreset.natureFocus => context.tr(
        'Enfoque natural',
        'Nature Focus',
      ),
      AppThemePreset.forestOperations => context.tr(
        'Bosque operativo',
        'Forest Operations',
      ),
      AppThemePreset.slateIndigo => context.tr(
        'Pizarra índigo',
        'Slate Indigo',
      ),
      AppThemePreset.tealGraphite => context.tr(
        'Verde azulado y grafito',
        'Teal Graphite',
      ),
      AppThemePreset.graphiteNight => context.tr(
        'Noche grafito',
        'Graphite Night',
      ),
      AppThemePreset.sunshineAurora => context.tr(
        'Aurora soleada',
        'Sunshine Aurora',
      ),
      AppThemePreset.sunsetTide => context.tr(
        'Marea al atardecer',
        'Sunset Tide',
      ),
    };
  }
}

class _ThemeSelectorOption extends StatelessWidget {
  const _ThemeSelectorOption({
    required this.preset,
    required this.label,
    required this.isDark,
  });

  final AppThemePreset preset;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final preview = AppPalette.fromPreset(preset, isDark: isDark);

    return Row(
      children: [
        _ThemeColorDot(color: preview.primary),
        const SizedBox(width: 4),
        _ThemeColorDot(color: preview.secondary),
        const SizedBox(width: 4),
        _ThemeColorDot(color: preview.gradientEnd),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _ThemeColorDot extends StatelessWidget {
  const _ThemeColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: context.palette.neutralSoft),
      ),
    );
  }
}

class _TextScaleControl extends StatelessWidget {
  const _TextScaleControl({required this.settings});

  final AppSettingsScope settings;

  @override
  Widget build(BuildContext context) {
    final percent = (settings.fontScale * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.tr('Tamaño general', 'General size'),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Text(
              '$percent%',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: context.palette.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: settings.fontScale,
          min: AppTypography.minFontScale,
          max: AppTypography.maxFontScale,
          divisions: AppTypography.fontScaleDivisions,
          label: '$percent%',
          onChanged: settings.onFontScaleChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr('Compacto', 'Compact'),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              context.tr('Normal', 'Normal'),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              context.tr('Grande', 'Large'),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettingsScope.of(context);

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.language_rounded,
            title: context.tr('Idioma', 'Language'),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr(
              'Elige el idioma que se usará en toda la aplicación.',
              'Choose the language used throughout the app.',
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<AppLanguage>(
            segments: const [
              ButtonSegment(
                value: AppLanguage.spanish,
                icon: Icon(Icons.translate_rounded),
                label: Text('Español'),
              ),
              ButtonSegment(
                value: AppLanguage.english,
                icon: Icon(Icons.language_rounded),
                label: Text('English'),
              ),
            ],
            selected: {settings.language},
            onSelectionChanged: (selection) {
              settings.onLanguageChanged(selection.single);
            },
          ),
        ],
      ),
    );
  }
}

class _OnboardingPreviewCard extends StatelessWidget {
  const _OnboardingPreviewCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.auto_stories_outlined,
            title: context.tr('Onboarding', 'Onboarding'),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr(
              'Abre la introducción para probarla otra vez.',
              'Open the introduction to test it again.',
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go(OnboardingPage.routePath),
              icon: const Icon(Icons.play_circle_outline_rounded),
              label: Text(context.tr('Ver onboarding', 'View onboarding')),
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusTimesCard extends StatelessWidget {
  const _FocusTimesCard();

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.timer_outlined,
            title: context.tr('Tiempos de enfoque', 'Focus times'),
          ),
          const SizedBox(height: 22),
          _InlineSlider(
            label: context.tr('Sesión de enfoque', 'Focus session'),
            value: settings.focusMinutes,
            min: 5,
            max: 90,
            onChanged: settings.onFocusMinutesChanged,
          ),
          const SizedBox(height: 20),
          _InlineSlider(
            label: context.tr('Descanso corto', 'Short break'),
            value: settings.shortBreakMinutes,
            min: 1,
            max: 20,
            onChanged: settings.onShortBreakMinutesChanged,
          ),
          const SizedBox(height: 20),
          _InlineSlider(
            label: context.tr('Descanso largo', 'Long break'),
            value: settings.longBreakMinutes,
            min: 5,
            max: 45,
            onChanged: settings.onLongBreakMinutesChanged,
          ),
        ],
      ),
    );
  }
}

class _ReportsCard extends StatelessWidget {
  const _ReportsCard();

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final palette = context.palette;
    final currentPath = settings.reportsDirectoryPath.trim();
    final usesExternalFolder = NativeFileManager.isExternalFolderReference(
      currentPath,
    );

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.folder_open_rounded,
            title: context.tr('Reportes', 'Reports'),
          ),
          const SizedBox(height: 12),
          Text(
            currentPath.isEmpty
                ? context.tr(
                    'Los PDF se guardan en Descargas cuando está disponible.',
                    'PDF files are saved in Downloads when available.',
                  )
                : usesExternalFolder
                ? context.tr(
                    'Carpeta externa seleccionada desde el gestor del sistema.',
                    'External folder selected in the system file manager.',
                  )
                : context.tr(
                    'Carpeta actual: $currentPath',
                    'Current folder: $currentPath',
                  ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final path = await _selectReportsFolder(
                  context,
                );
                if (path == null || !context.mounted) {
                  return;
                }

                settings.onReportsDirectoryPathChanged(path);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.tr(
                        'Carpeta de reportes seleccionada.',
                        'Reports folder selected.',
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.folder_open_rounded),
              label: Text(context.tr('Seleccionar carpeta', 'Select folder')),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await settings.onUseDefaultReportsDirectory();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.tr(
                          'Carpeta de reportes configurada.',
                          'Reports folder configured.',
                        ),
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.download_rounded),
              label: Text(context.tr('Usar Descargas', 'Use Downloads')),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                final destination = await _exportDatabaseBackup(
                  context,
                  settings,
                );
                if (destination == null || !context.mounted) {
                  return;
                }

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.tr(
                          'Copia exportada en: ${_displayDestination(context, destination)}',
                          'Backup exported to: ${_displayDestination(context, destination)}',
                        ),
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.backup_rounded),
              label: Text(
                context.tr('Exportar base de datos', 'Export database'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final path = await _selectBackupImportFolder(
                  context,
                );
                if (path == null || !context.mounted) {
                  return;
                }

                final password = await _requestBackupPassword(context);
                if (password == null || !context.mounted) return;

                try {
                  await settings.onImportDatabaseBackup(path, password);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.tr(
                            'Copia preparada. Reinicia la app para aplicarla.',
                            'Backup prepared. Restart the app to apply it.',
                          ),
                        ),
                      ),
                    );
                  }
                } on FileSystemException catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.message)),
                    );
                  }
                }
              },
              icon: const Icon(Icons.restore_rounded),
              label: Text(
                context.tr('Importar base de datos', 'Import database'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _selectReportsFolder(
    BuildContext context,
  ) async {
    try {
      final selection = await NativeFileManager.pickFolder();
      if (selection != null) {
        return selection.uri;
      }
    } on PlatformException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.message ??
                  context.tr(
                    'No se pudo abrir el gestor de carpetas.',
                    'The folder manager could not be opened.',
                  ),
            ),
          ),
        );
      }
    }

    return null;
  }

  Future<String?> _selectBackupImportFolder(
    BuildContext context,
  ) async {
    try {
      final path = await NativeFileManager.pickBackupImportFolder();
      if (path != null && path.trim().isNotEmpty) {
        return path;
      }
    } on PlatformException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.message ??
                  context.tr(
                    'No se pudo abrir el gestor de archivos.',
                    'The file manager could not be opened.',
                  ),
            ),
          ),
        );
      }
    }

    return null;
  }

  Future<String?> _exportDatabaseBackup(
    BuildContext context,
    AppSettingsScope settings,
  ) async {
    try {
      final selection = await NativeFileManager.pickExportFolder();
      if (selection != null) {
        settings.onReportsDirectoryPathChanged(selection.uri);
        return settings.onExportDatabaseBackup();
      }
    } on PlatformException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.message ??
                  context.tr(
                    'No se pudo abrir el gestor de carpetas.',
                    'The folder manager could not be opened.',
                  ),
            ),
          ),
        );
      }
      return null;
    } on FileSystemException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
      return null;
    }

    return settings.onExportDatabaseBackup();
  }

  Future<String?> _requestBackupPassword(BuildContext context) async {
    final passwordController = TextEditingController();
    var obscurePassword = true;
    var errorText = '';
    try {
      return await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              context.tr(
                'Abrir copia protegida',
                'Open protected backup',
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr(
                      'Introduce la única clave maestra de MichiDoro. '
                          'Es la que guardaste en tu gestor de contraseñas.',
                      'Enter your single MichiDoro master password. '
                          'It is the one saved in your password manager.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: context.tr('Contraseña', 'Password'),
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => obscurePassword = !obscurePassword,
                        ),
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                        ),
                      ),
                    ),
                  ),
                  if (errorText.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorText,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(context.tr('Cancelar', 'Cancel')),
              ),
              FilledButton(
                onPressed: () {
                  final password = passwordController.text;
                  if (password.length < 12) {
                    setState(() {
                      errorText = context.tr(
                        'La contraseña debe tener al menos 12 caracteres.',
                        'The password must contain at least 12 characters.',
                      );
                    });
                    return;
                  }
                  Navigator.of(dialogContext).pop(password);
                },
                child: Text(
                  context.tr(
                    'Abrir',
                    'Open',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } finally {
      passwordController
        ..clear()
        ..dispose();
    }
  }

  String _displayDestination(BuildContext context, String destination) {
    if (NativeFileManager.isExternalFolderReference(destination)) {
      return context.tr(
        'carpeta externa seleccionada',
        'selected external folder',
      );
    }

    return destination;
  }
}

class _NotificationsCard extends StatefulWidget {
  const _NotificationsCard();

  @override
  State<_NotificationsCard> createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<_NotificationsCard>
    with WidgetsBindingObserver {
  late Future<RoutineReminderCapability?> _capability;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _capability = RoutineReminderPlatform.getCapability();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    setState(() {
      _capability = RoutineReminderPlatform.getCapability();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final palette = context.palette;

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.notifications_active_outlined,
            title: context.tr('Notificaciones', 'Notifications'),
          ),
          FutureBuilder<RoutineReminderCapability?>(
            future: _capability,
            builder: (context, snapshot) {
              final capability = snapshot.data;
              if (capability == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 18),
                child: RoutineReminderCapabilityTile(
                  capability: capability,
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<PomodoroCompletionSound>(
            value: settings.completionSound,
            decoration: InputDecoration(
              labelText: context.tr('Biblioteca de sonidos', 'Sound library'),
              prefixIcon: const Icon(Icons.music_note_rounded),
            ),
            items: [
              for (final sound in PomodoroCompletionSound.values)
                DropdownMenuItem(
                  value: sound,
                  child: Text(_soundLabel(context, sound)),
                ),
            ],
            onChanged: settings.notificationsEnabled
                ? (value) {
                    if (value != null) {
                      settings.onCompletionSoundChanged(value);
                    }
                  }
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            _soundDescription(context, settings.completionSound),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: settings.notificationsEnabled
                  ? settings.onPreviewCompletionSound
                  : null,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(context.tr('Escuchar sonido', 'Preview sound')),
            ),
          ),
          const SizedBox(height: 14),
          _CompletionVibrationTile(
            enabled: settings.completionVibrationEnabled,
            pattern: settings.completionVibrationPattern,
            onChanged: settings.onCompletionVibrationChanged,
            onPatternChanged: settings.onCompletionVibrationPatternChanged,
            onPreview: settings.onPreviewCompletionVibration,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: settings.notificationsEnabled
                  ? () async {
                      await settings.onTestNotification();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.tr(
                                'Tarea programada de prueba enviada.',
                                'Test scheduled-task alert sent.',
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              icon: const Icon(Icons.notifications_active_outlined),
              label: Text(
                context.tr(
                  'Probar tarea programada',
                  'Test scheduled task',
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _NotificationTile(
            icon: Icons.volume_up_outlined,
            title: context.tr('Alertas sonoras', 'Sound alerts'),
            subtitle: context.tr(
              'Sonido suave al terminar el ciclo',
              'A soft sound when the cycle ends',
            ),
            value: settings.focusAlertsEnabled,
            onChanged: settings.onFocusAlertsEnabledChanged,
          ),
          const SizedBox(height: 14),
          _NotificationTile(
            icon: Icons.desktop_windows_outlined,
            title: context.tr('Sistema', 'System'),
            subtitle: context.tr(
              'Notificaciones nativas del sistema',
              'Native system notifications',
            ),
            value: settings.notificationsEnabled,
            onChanged: settings.onNotificationsEnabledChanged,
          ),
        ],
      ),
    );
  }

  String _soundLabel(
    BuildContext context,
    PomodoroCompletionSound sound,
  ) {
    return switch (sound) {
      PomodoroCompletionSound.softBell => context.tr(
        'Campana suave',
        'Soft bell',
      ),
      PomodoroCompletionSound.lightTap => context.tr(
        'Toque ligero',
        'Light tap',
      ),
      PomodoroCompletionSound.warmChime => context.tr(
        'Campanilla cálida',
        'Warm chime',
      ),
      PomodoroCompletionSound.crystalChime => context.tr(
        'Cristal claro',
        'Crystal chime',
      ),
      PomodoroCompletionSound.calmPulse => context.tr(
        'Pulso calmado',
        'Calm pulse',
      ),
      PomodoroCompletionSound.deepChime => context.tr(
        'Campana profunda',
        'Deep chime',
      ),
      PomodoroCompletionSound.digitalZen => context.tr(
        'Zen digital',
        'Digital zen',
      ),
      PomodoroCompletionSound.silent => context.tr('Silencio', 'Silent'),
    };
  }

  String _soundDescription(
    BuildContext context,
    PomodoroCompletionSound sound,
  ) {
    return switch (sound) {
      PomodoroCompletionSound.softBell => context.tr(
        'Campana breve y clara para cerrar el bloque.',
        'A short, clear bell to close the block.',
      ),
      PomodoroCompletionSound.lightTap => context.tr(
        'Señal corta y discreta para avisos rápidos.',
        'A short, subtle signal for quick alerts.',
      ),
      PomodoroCompletionSound.warmChime => context.tr(
        'Notas suaves con un cierre más agradable.',
        'Soft notes with a warmer finish.',
      ),
      PomodoroCompletionSound.crystalChime => context.tr(
        'Secuencia limpia y brillante sin sonar agresiva.',
        'A clean, bright sequence without sounding harsh.',
      ),
      PomodoroCompletionSound.calmPulse => context.tr(
        'Dos pulsos redondos para una alerta tranquila.',
        'Two rounded pulses for a calm alert.',
      ),
      PomodoroCompletionSound.deepChime => context.tr(
        'Tono grave y reposado para descansos largos.',
        'A deep, relaxed tone for long breaks.',
      ),
      PomodoroCompletionSound.digitalZen => context.tr(
        'Secuencia moderna, corta y menos invasiva.',
        'A modern, short, less intrusive sequence.',
      ),
      PomodoroCompletionSound.silent => context.tr(
        'No reproducir sonido al finalizar.',
        'Do not play a sound when finished.',
      ),
    };
  }
}

class _TypographyPresetCard extends StatefulWidget {
  const _TypographyPresetCard();

  @override
  State<_TypographyPresetCard> createState() => _TypographyPresetCardState();
}

class _TypographyPresetCardState extends State<_TypographyPresetCard> {
  late AppTypographyPreset _draftPreset;
  var _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }

    _draftPreset = AppSettingsScope.of(context).typographyPreset;
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettingsScope.of(context);
    final previewTheme = AppTypography.textTheme(
      colorScheme: Theme.of(context).colorScheme,
      fontScale: settings.fontScale,
      preset: _draftPreset,
    );
    final hasChanges = _draftPreset != settings.typographyPreset;

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.text_fields_rounded,
            title: context.tr('Tipografía', 'Typography'),
          ),
          const SizedBox(height: 12),
          Text(
            context.tr(
              'Aplicada: ${_typographyLabel(context, settings.typographyPreset)} '
                  '(${settings.typographyPreset.familyLabel})',
              'Applied: ${_typographyLabel(context, settings.typographyPreset)} '
                  '(${settings.typographyPreset.familyLabel})',
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.primaryMuted.withValues(alpha: 0.34),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: palette.neutralSoft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Vista previa', 'Preview'),
                  style: previewTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr('Un año de enfoque', 'A year of focus'),
                  style: previewTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr(
                    'MichiDoro se adapta a tu ritmo diario.',
                    'MichiDoro adapts to your daily rhythm.',
                  ),
                  style: previewTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text('25:00', style: previewTheme.headlineLarge),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: [
              for (final preset in AppTypographyPreset.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ChoiceChip(
                      label: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${_typographyLabel(context, preset)} · '
                          '${preset.familyLabel}',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontFamily: preset.fontFamily,
                                color: palette.textPrimary,
                              ),
                        ),
                      ),
                      selected: _draftPreset == preset,
                      selectedColor: palette.primaryMuted,
                      checkmarkColor: palette.primary,
                      onSelected: (_) => setState(() => _draftPreset = preset),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _typographyDescription(context, _draftPreset),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: hasChanges
                  ? () {
                      settings.onTypographyPresetChanged(_draftPreset);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.tr(
                              'Tipografía aplicada globalmente.',
                              'Typography applied throughout the app.',
                            ),
                          ),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.save_outlined),
              label: Text(
                hasChanges
                    ? context.tr('Guardar cambios', 'Save changes')
                    : context.tr('Cambios guardados', 'Changes saved'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _typographyLabel(
    BuildContext context,
    AppTypographyPreset preset,
  ) {
    return switch (preset) {
      AppTypographyPreset.moderna => context.tr('Moderna', 'Modern'),
      AppTypographyPreset.serio => context.tr('Seria', 'Serious'),
      AppTypographyPreset.normal => context.tr('Normal', 'Standard'),
    };
  }

  String _typographyDescription(
    BuildContext context,
    AppTypographyPreset preset,
  ) {
    return switch (preset) {
      AppTypographyPreset.moderna => context.tr(
        'Limpia y actual para paneles.',
        'Clean and current for dashboards.',
      ),
      AppTypographyPreset.serio => context.tr(
        'Más formal para reportes y enfoque profundo.',
        'More formal for reports and deep focus.',
      ),
      AppTypographyPreset.normal => context.tr(
        'Neutral y familiar para uso diario.',
        'Neutral and familiar for daily use.',
      ),
    };
  }
}

// Kept temporarily while the new V3 typography card replaces the old layout.
// ignore: unused_element
class _TypographyCard extends StatelessWidget {
  const _TypographyCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 64,
            decoration: BoxDecoration(
              color: palette.secondarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.text_fields_rounded,
              color: palette.secondary,
              size: 32,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Tipografía', 'Typography'),
                  style:
                      Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        color: palette.tertiary,
                        fontSize: AppDesignTokens.sectionTitleFontSize,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr(
                    'Sora (Sans-Serif) - Diseñada para facilitar la lectura.',
                    'Sora (Sans-Serif) - Designed for readability.',
                  ),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: palette.textSecondary),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text(context.tr('Restablecer', 'Reset')),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {},
                        child: Text(context.tr('Aplicar todo', 'Apply all')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Icon(icon, color: palette.tertiary, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: palette.tertiary,
              fontSize: AppDesignTokens.sectionTitleFontSize,
            ),
          ),
        ),
      ],
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: palette.primaryMuted.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: palette.textPrimary,
              ),
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _InlineSlider extends StatelessWidget {
  const _InlineSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleSmall),
            ),
            Text(
              '$value min',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: palette.primary),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max).toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          onChanged: (newValue) => onChanged(newValue.round()),
        ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.primaryMuted.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        children: [
          Icon(icon, color: palette.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _CompletionVibrationTile extends StatelessWidget {
  const _CompletionVibrationTile({
    required this.enabled,
    required this.pattern,
    required this.onChanged,
    required this.onPatternChanged,
    required this.onPreview,
  });

  final bool enabled;
  final PomodoroVibrationPattern pattern;
  final ValueChanged<bool> onChanged;
  final ValueChanged<PomodoroVibrationPattern> onPatternChanged;
  final Future<void> Function() onPreview;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final previewLabel = context.tr('Probar vibración', 'Test vibration');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.primaryMuted.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.vibration_rounded, color: palette.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(
                        'Vibrar al finalizar',
                        'Vibrate when finished',
                      ),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      context.tr(
                        'Vibración real al terminar enfoque o descanso',
                        'Physical vibration when focus or a break finishes',
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Switch.adaptive(value: enabled, onChanged: onChanged),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<PomodoroVibrationPattern>(
            value: pattern,
            decoration: InputDecoration(
              labelText: context.tr(
                'Patrón de vibración',
                'Vibration pattern',
              ),
              prefixIcon: const Icon(Icons.graphic_eq_rounded),
            ),
            items: [
              for (final option in PomodoroVibrationPattern.values)
                DropdownMenuItem(
                  value: option,
                  child: Text(_vibrationPatternLabel(context, option)),
                ),
            ],
            onChanged: enabled
                ? (value) {
                    if (value != null) {
                      onPatternChanged(value);
                    }
                  }
                : null,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _vibrationPatternDescription(context, pattern),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: previewLabel,
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: enabled ? () async => onPreview() : null,
                icon: const Icon(Icons.touch_app_rounded),
                label: Text(previewLabel),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _vibrationPatternLabel(
    BuildContext context,
    PomodoroVibrationPattern value,
  ) {
    return switch (value) {
      PomodoroVibrationPattern.light => context.tr('Suave', 'Light'),
      PomodoroVibrationPattern.normal => context.tr('Normal', 'Normal'),
      PomodoroVibrationPattern.double => context.tr('Doble', 'Double'),
      PomodoroVibrationPattern.intense => context.tr('Intensa', 'Intense'),
    };
  }

  String _vibrationPatternDescription(
    BuildContext context,
    PomodoroVibrationPattern value,
  ) {
    return switch (value) {
      PomodoroVibrationPattern.light => context.tr(
        'Vibración corta de intensidad baja.',
        'A short, low-intensity vibration.',
      ),
      PomodoroVibrationPattern.normal => context.tr(
        'Vibración clara de intensidad media.',
        'A clear, medium-intensity vibration.',
      ),
      PomodoroVibrationPattern.double => context.tr(
        'Dos vibraciones separadas para distinguir el final.',
        'Two separated vibrations to make completion distinct.',
      ),
      PomodoroVibrationPattern.intense => context.tr(
        'Dos pulsos largos a intensidad máxima.',
        'Two long pulses at maximum intensity.',
      ),
    };
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: context.palette.textSecondary),
      ),
    );
  }
}
