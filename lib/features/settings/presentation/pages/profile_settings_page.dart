import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:pomodoro_app_v1/shared/templates/app_shell.dart';
import 'package:pomodoro_app_v1/shared/templates/page_header.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  static const routePath = '/settings/profile';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettingsScope.of(context);

    return AppShell(
      selectedIndex: 4,
      showHeader: false,
      child: ListView(
        padding: AppCardPaddings.detailPage,
        children: [
          PageHeader(
            title: context.tr('Perfil', 'Profile'),
            subtitle: context.tr(
              'Personaliza tu foto y nombre visible.',
              'Customize your photo and display name.',
            ),
            showBack: true,
          ),
          Padding(
            padding: AppCardPaddings.standard,
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: palette.primaryMuted,
                      foregroundImage: _profileImage(settings.profileImagePath),
                      child: _profileImage(settings.profileImagePath) == null
                          ? Text(
                              _avatarLabel(settings),
                              style: TextStyle(
                                color: palette.primary,
                                fontSize: AppDesignTokens.sectionTitleFontSize,
                                fontWeight: FontWeight.w900,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextFormField(
                    initialValue: settings.profileName,
                    onChanged: settings.onProfileNameChanged,
                    decoration: InputDecoration(
                      labelText: context.tr('Nombre', 'Name'),
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: settings.profileEmail,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: settings.onProfileEmailChanged,
                    decoration: InputDecoration(
                      labelText: context.tr('Correo electrónico', 'Email'),
                      prefixIcon: const Icon(Icons.alternate_email_rounded),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: settings.profileImagePath,
                    onChanged: settings.onProfileImagePathChanged,
                    decoration: InputDecoration(
                      labelText: context.tr(
                        'Ruta de imagen local',
                        'Local image path',
                      ),
                      hintText: r'C:\\Users\\...\\photo.png',
                      prefixIcon: const Icon(Icons.image_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _avatarLabel(AppSettingsScope settings) {
    if (settings.profileName.trim().isNotEmpty) {
      return settings.profileName.trim().characters.first.toUpperCase();
    }

    return 'U';
  }

  ImageProvider? _profileImage(String path) {
    if (path.isEmpty) {
      return null;
    }

    final file = File(path);
    if (!file.existsSync()) {
      return null;
    }

    return FileImage(file);
  }
}
