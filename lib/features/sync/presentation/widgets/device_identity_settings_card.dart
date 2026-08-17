import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/features/sync/domain/entities/sync_storage_config.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/device_identity_controller.dart';
import 'package:pomodoro_app_v1/features/sync/presentation/controllers/sync_storage_controller.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';
import 'package:pomodoro_app_v1/shared/molecules/glass_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class DeviceIdentitySettingsSection extends StatefulWidget {
  const DeviceIdentitySettingsSection({
    required this.identityController,
    required this.storageController,
    super.key,
  });

  final DeviceIdentityController identityController;
  final SyncStorageController storageController;

  @override
  State<DeviceIdentitySettingsSection> createState() =>
      _DeviceIdentitySettingsSectionState();
}

class _DeviceIdentitySettingsSectionState
    extends State<DeviceIdentitySettingsSection> {
  late final TextEditingController _nameController;
  late final FocusNode _nameFocusNode;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.identityController.friendlyName.value,
    );
    _nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        if (widget.storageController.mode.value !=
            SyncStorageMode.multipleDevices) {
          return const SizedBox.shrink();
        }

        final savedName = widget.identityController.friendlyName.value;
        if (!_nameFocusNode.hasFocus && _nameController.text != savedName) {
          _nameController.text = savedName;
        }
        final shortId = widget.identityController.shortInstallationId;

        return Padding(
          padding: const EdgeInsets.only(top: 26),
          child: GlassCard(
            key: const ValueKey('device-identity-settings-card'),
            padding: AppCardPaddings.compact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.phone_android_rounded,
                      color: context.palette.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.tr('Este dispositivo', 'This device'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr(
                    'MichiFocus crea la identidad automáticamente. El nombre '
                        'solo sirve para reconocer de qué teléfono llega un cambio.',
                    'MichiFocus creates the identity automatically. The name is '
                        'only used to recognize which phone a change came from.',
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const ValueKey('device-friendly-name-field'),
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  enabled: !_isSaving,
                  maxLength: 60,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: context.tr(
                      'Nombre de este teléfono',
                      'Name of this phone',
                    ),
                    helperText: shortId.isEmpty
                        ? null
                        : context.tr(
                            'Identificador interno: …$shortId',
                            'Internal identifier: …$shortId',
                          ),
                  ),
                  onSubmitted: (_) => _save(),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    key: const ValueKey('save-device-friendly-name'),
                    onPressed: _isSaving ? null : _save,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(context.tr('Guardar nombre', 'Save name')),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr(
                    'Puedes renombrarlo después: su identidad interna no cambia '
                        'y no se duplican datos.',
                    'You can rename it later: its internal identity does not '
                        'change and data is not duplicated.',
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    final failureMessage = context.tr(
      'Escribe un nombre válido para este teléfono.',
      'Enter a valid name for this phone.',
    );
    final successMessage = context.tr(
      'Nombre del dispositivo guardado.',
      'Device name saved.',
    );
    setState(() => _isSaving = true);
    try {
      await widget.identityController.rename(_nameController.text);
      _showMessage(successMessage);
      if (!mounted) return;
      FocusScope.of(context).unfocus();
    } on Object {
      _showMessage(failureMessage);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
