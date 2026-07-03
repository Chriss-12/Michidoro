import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro_app_v1/app/state/app_settings_scope.dart';
import 'package:pomodoro_app_v1/app/theme/app_design_tokens.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.showSettings = false,
    this.centerTitle = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final bool showSettings;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      child: Column(
        crossAxisAlignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          _BrandBar(showBack: showBack, showSettings: showSettings),
          if (title.isNotEmpty) ...[
            SizedBox(height: centerTitle ? 42 : 26),
            Text(
              title,
              textAlign: centerTitle ? TextAlign.center : TextAlign.start,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: palette.tertiary,
                fontSize: centerTitle ? 26 : 28,
                fontWeight: FontWeight.w600,
                height: 1.18,
                letterSpacing: -0.3,
              ),
            ),
          ],
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: centerTitle ? TextAlign.center : TextAlign.start,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: palette.textSecondary,
                fontSize: centerTitle ? 16 : 15,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BrandBar extends StatelessWidget {
  const _BrandBar({required this.showBack, required this.showSettings});

  final bool showBack;
  final bool showSettings;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final settings = AppSettingsScope.of(context);

    Widget leading;
    if (showBack) {
      leading = IconButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
        icon: Icon(Icons.arrow_back_rounded, color: palette.tertiary),
      );
    } else if (showSettings) {
      leading = Icon(
        Icons.settings_outlined,
        color: palette.tertiary,
        size: 50,
      );
    } else {
      leading = _Avatar(settings: settings);
    }

    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Align(alignment: Alignment.centerLeft, child: leading),
        ),
        Expanded(
          child: Text(
            'MichiFocus',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: palette.tertiary,
              fontSize: AppDesignTokens.sectionTitleFontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
            ),
          ),
        ),
        Icon(
          Icons.notifications_none_rounded,
          color: palette.tertiary,
          size: 25,
        ),
        if (showSettings) ...[
          const SizedBox(width: 14),
          _Avatar(settings: settings, radius: 16),
        ],
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.settings, this.radius = 22});

  final AppSettingsScope settings;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final image = _profileImage(settings.profileImagePath);

    return CircleAvatar(
      radius: radius,
      backgroundColor: palette.primaryMuted,
      foregroundImage: image,
      child: image == null
          ? Text(
              settings.avatarIndex == 1 ? 'CH' : 'C',
              style: TextStyle(
                color: palette.tertiary,
                fontSize: radius * 0.62,
                fontWeight: FontWeight.w800,
              ),
            )
          : null,
    );
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
