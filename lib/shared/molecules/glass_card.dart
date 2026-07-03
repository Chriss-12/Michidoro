import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = AppCardPaddings.standard,
    this.margin = EdgeInsets.zero,
    this.borderRadius = 24,
    this.color,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? palette.glass,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: palette.neutralSoft),
          ),
          child: child,
        ),
      ),
    );
  }
}
