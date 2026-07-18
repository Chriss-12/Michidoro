import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_controller.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/app/theme/app_typography.dart';
import 'package:pomodoro_app_v1/features/settings/presentation/pages/directory_picker_page.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routePath = '/settings';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppCardPaddings.page,
      children: const [
        SizedBox(height: 24),
        _ProfileCard(),
        SizedBox(height: 26),
        _AppearanceCard(),
        SizedBox(height: 26),
        _FocusTimesCard(),
        SizedBox(height: 26),
        _ReportsCard(),
        SizedBox(height: 26),
        _NotificationsCard(),
        SizedBox(height: 26),
        _TypographyPresetCard(),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colorScheme = Theme.of(context).colorScheme;
    final settings = AppSettingsScope.of(context);
    final image = _profileImage(settings.profileImagePath);

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: palette.primaryMuted,
                  foregroundImage: image,
                  child: image == null
                      ? Text(
                          _avatarLabel(settings),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: palette.primary,
                                fontWeight: FontWeight.w900,
                              ),
                        )
                      : null,
                ),
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: palette.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: colorScheme.onPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 38),
            const _FieldLabel('Nombre de usuario'),
            TextFormField(
              key: ValueKey('profile-name-${settings.profileName}'),
              initialValue: settings.profileName,
              onChanged: settings.onProfileNameChanged,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 18),
            const _FieldLabel('Correo electrónico'),
            TextFormField(
              key: ValueKey('profile-email-${settings.profileEmail}'),
              initialValue: settings.profileEmail,
              keyboardType: TextInputType.emailAddress,
              onChanged: settings.onProfileEmailChanged,
              decoration: const InputDecoration(
                hintText: 'tu-correo@ejemplo.com',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
            ),
            const SizedBox(height: 18),
            const _FieldLabel('Foto local'),
            TextFormField(
              key: ValueKey('profile-image-${settings.profileImagePath}'),
              initialValue: settings.profileImagePath,
              onChanged: settings.onProfileImagePathChanged,
              decoration: const InputDecoration(
                hintText: r'C:\Users\TuUsuario\Pictures\foto.png',
                prefixIcon: Icon(Icons.image_outlined),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              children: [
                for (var index = 0; index < 4; index++)
                  ChoiceChip(
                    label: Text(_avatarLabelForIndex(index)),
                    selected: settings.avatarIndex == index,
                    onSelected: (_) => settings.onAvatarChanged(index),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Perfil actualizado.')),
                );
              },
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider? _profileImage(String path) {
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

    return _avatarLabelForIndex(settings.avatarIndex);
  }

  String _avatarLabelForIndex(int index) {
    return switch (index) {
      0 => 'C',
      1 => 'CH',
      2 => 'P',
      _ => 'A',
    };
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
          const _SectionTitle(
            icon: Icons.palette_outlined,
            title: 'Apariencia',
          ),
          const SizedBox(height: 18),
          _ModeTile(
            label: 'Modo Claro',
            value: !settings.isDarkMode,
            onChanged: (value) => settings.onDarkModeChanged(!value),
          ),
          const SizedBox(height: 14),
          _ModeTile(
            label: 'Modo Oscuro',
            value: settings.isDarkMode,
            onChanged: settings.onDarkModeChanged,
            disabled: true,
          ),
          const SizedBox(height: 18),
          _TextScaleControl(settings: settings),
          const SizedBox(height: 18),
          Text(
            'Tema de color',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final preset in AppThemePreset.values)
                ChoiceChip(
                  label: Text(preset.label),
                  selected: settings.themePreset == preset,
                  onSelected: (_) => settings.onThemeChanged(preset),
                  selectedColor: palette.primaryMuted,
                  checkmarkColor: palette.primary,
                  labelStyle: TextStyle(
                    color: settings.themePreset == preset
                        ? palette.primary
                        : palette.textSecondary,
                    fontWeight: settings.themePreset == preset
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tema actual: ${settings.themePreset.label}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
        ],
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
                'Tamaño general',
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
            Text('Compacto', style: Theme.of(context).textTheme.labelSmall),
            Text('Normal', style: Theme.of(context).textTheme.labelSmall),
            Text('Grande', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ],
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
          const _SectionTitle(
            icon: Icons.timer_outlined,
            title: 'Tiempos de Enfoque',
          ),
          const SizedBox(height: 22),
          _InlineSlider(
            label: 'Sesión de Enfoque',
            value: settings.focusMinutes,
            min: 5,
            max: 90,
            onChanged: settings.onFocusMinutesChanged,
          ),
          const SizedBox(height: 20),
          _InlineSlider(
            label: 'Descanso Corto',
            value: settings.shortBreakMinutes,
            min: 1,
            max: 20,
            onChanged: settings.onShortBreakMinutesChanged,
          ),
          const SizedBox(height: 20),
          _InlineSlider(
            label: 'Descanso Largo',
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

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.folder_open_rounded,
            title: 'Reportes',
          ),
          const SizedBox(height: 12),
          Text(
            currentPath.isEmpty
                ? 'Los PDF se guardan en Descargas cuando esta disponible.'
                : 'Carpeta actual: $currentPath',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final path = await context.push<String>(
                  DirectoryPickerPage.routePath,
                  extra: currentPath,
                );
                if (path == null || !context.mounted) {
                  return;
                }

                settings.onReportsDirectoryPathChanged(path);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Carpeta de reportes seleccionada.'),
                  ),
                );
              },
              icon: const Icon(Icons.folder_open_rounded),
              label: const Text('Seleccionar carpeta'),
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
                    const SnackBar(
                      content: Text('Carpeta de reportes configurada.'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.download_rounded),
              label: const Text('Usar Descargas'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                await settings.onExportDatabaseBackup();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Backup de base de datos exportado.'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.backup_rounded),
              label: const Text('Exportar base de datos'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final path = await context.push<String>(
                  DirectoryPickerPage.routePath,
                  extra: currentPath,
                );
                if (path == null || !context.mounted) {
                  return;
                }

                try {
                  await settings.onImportDatabaseBackup(path);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Backup preparado. Reinicia la app para aplicarlo.',
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
              label: const Text('Importar base de datos'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsCard extends StatelessWidget {
  const _NotificationsCard();

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final palette = context.palette;

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.notifications_active_outlined,
            title: 'Notificaciones',
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<PomodoroCompletionSound>(
            value: settings.completionSound,
            decoration: const InputDecoration(
              labelText: 'Tono',
              prefixIcon: Icon(Icons.music_note_rounded),
            ),
            items: [
              for (final sound in PomodoroCompletionSound.values)
                DropdownMenuItem(
                  value: sound,
                  child: Text(sound.label),
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
            settings.completionSound.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
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
                          const SnackBar(
                            content: Text(
                              'Notificacion de prueba enviada.',
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Probar notificacion'),
            ),
          ),
          const SizedBox(height: 18),
          _NotificationTile(
            icon: Icons.volume_up_outlined,
            title: 'Alertas Sonoras',
            subtitle: 'Sonido suave al terminar ciclo',
            value: settings.focusAlertsEnabled,
            onChanged: settings.onFocusAlertsEnabledChanged,
          ),
          const SizedBox(height: 14),
          _NotificationTile(
            icon: Icons.desktop_windows_outlined,
            title: 'Escritorio',
            subtitle: 'Notificaciones nativas del sistema',
            value: settings.notificationsEnabled,
            onChanged: settings.onNotificationsEnabledChanged,
          ),
        ],
      ),
    );
  }
}

class _TypographyPresetCard extends StatelessWidget {
  const _TypographyPresetCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettingsScope.of(context);

    return GlassCard(
      padding: AppCardPaddings.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.text_fields_rounded,
            title: 'Tipografia',
          ),
          const SizedBox(height: 12),
          Text(
            'Seleccion actual: ${settings.typographyPreset.label} (${settings.typographyPreset.familyLabel})',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final preset in AppTypographyPreset.values)
                ChoiceChip(
                  label: Text('${preset.label} - ${preset.familyLabel}'),
                  selected: settings.typographyPreset == preset,
                  onSelected: (_) => settings.onTypographyPresetChanged(preset),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            settings.typographyPreset.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
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
                  'Tipografía',
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
                  'Sora (Sans-Serif) - Diseñada para legibilidad en estados de flujo.',
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
                        child: const Text('Restablecer'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {},
                        child: const Text('Aplicar Todo'),
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
    this.disabled = false,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: disabled
            ? palette.background.withValues(alpha: 0.5)
            : palette.primaryMuted.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.neutralSoft),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: disabled ? palette.neutral : palette.textPrimary,
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
