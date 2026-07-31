import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';
import 'package:pomodoro_app_v1/l10n/app_localizations_context.dart';

class LocalImagePickerPage extends StatefulWidget {
  const LocalImagePickerPage({super.key, this.initialPath});

  static const routePath = '/settings/local-image-picker';

  final String? initialPath;

  @override
  State<LocalImagePickerPage> createState() => _LocalImagePickerPageState();
}

class _LocalImagePickerPageState extends State<LocalImagePickerPage> {
  static const _imageExtensions = {'.jpg', '.jpeg', '.png', '.webp', '.gif'};

  Directory? _currentDirectory;
  List<Directory> _roots = const [];
  List<Directory> _directories = const [];
  List<File> _images = const [];
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialDirectory();
  }

  Future<void> _loadInitialDirectory() async {
    final roots = await _availableRoots();
    final initialPath = widget.initialPath?.trim();
    final initialFile = initialPath != null && initialPath.isNotEmpty
        ? File(initialPath)
        : null;
    final initialDirectory = initialFile != null && initialFile.existsSync()
        ? initialFile.parent
        : roots.firstOrNull;

    setState(() => _roots = roots);
    await _openDirectory(initialDirectory);
  }

  Future<void> _openDirectory(Directory? directory) async {
    if (directory == null) {
      setState(() {
        _currentDirectory = null;
        _directories = const [];
        _images = const [];
        _errorMessage = context.tr(
          'No se encontraron carpetas accesibles.',
          'No accessible folders were found.',
        );
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final entities = directory.listSync();
      final directories =
          entities
              .whereType<Directory>()
              .where((child) => !_isHidden(child))
              .toList()
            ..sort(_sortByPath);
      final images =
          entities
              .whereType<File>()
              .where((file) => _imageExtensions.contains(_extension(file.path)))
              .toList()
            ..sort(_sortByPath);

      setState(() {
        _currentDirectory = directory;
        _directories = directories;
        _images = images;
        _isLoading = false;
      });
    } on FileSystemException {
      setState(() {
        _currentDirectory = directory;
        _directories = const [];
        _images = const [];
        _errorMessage = context.tr(
          'No se pudo leer esta carpeta.',
          'This folder could not be read.',
        );
        _isLoading = false;
      });
    }
  }

  Future<List<Directory>> _availableRoots() async {
    final roots = <Directory>[];

    Future<void> addIfExists(Directory? directory) async {
      if (directory == null || !directory.existsSync()) {
        return;
      }
      if (roots.any((root) => root.path == directory.path)) {
        return;
      }
      roots.add(directory);
    }

    await addIfExists(await getDownloadsDirectory());
    await addIfExists(await getApplicationDocumentsDirectory());

    if (Platform.isAndroid) {
      await addIfExists(Directory('/storage/emulated/0/Pictures'));
      await addIfExists(Directory('/storage/emulated/0/DCIM'));
      await addIfExists(Directory('/storage/emulated/0/Download'));
    } else if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      if (userProfile != null && userProfile.trim().isNotEmpty) {
        await addIfExists(Directory('$userProfile\\Pictures'));
        await addIfExists(Directory('$userProfile\\Downloads'));
        await addIfExists(Directory(userProfile));
      }
    } else {
      final home = Platform.environment['HOME'];
      if (home != null && home.trim().isNotEmpty) {
        await addIfExists(Directory('$home/Pictures'));
        await addIfExists(Directory('$home/Downloads'));
        await addIfExists(Directory(home));
      }
    }

    return roots;
  }

  int _sortByPath(FileSystemEntity first, FileSystemEntity second) {
    return first.path.toLowerCase().compareTo(second.path.toLowerCase());
  }

  bool _isHidden(Directory directory) {
    final name = _displayName(directory);
    return name.startsWith('.') || name == r'$RECYCLE.BIN';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final currentDirectory = _currentDirectory;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Seleccionar foto', 'Select photo')),
      ),
      body: ListView(
        padding: AppCardPaddings.page,
        children: [
          Text(
            currentDirectory?.path ??
                context.tr('Sin carpeta seleccionada', 'No folder selected'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final root in _roots)
                ActionChip(
                  label: Text(_displayName(root)),
                  onPressed: () => _openDirectory(root),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_parentOf(currentDirectory) case final parent?)
            ListTile(
              leading: const Icon(Icons.arrow_upward_rounded),
              title: Text(context.tr('Subir carpeta', 'Go up')),
              subtitle: Text(parent.path),
              onTap: () => _openDirectory(parent),
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: palette.textSecondary),
              ),
            )
          else ...[
            for (final directory in _directories)
              ListTile(
                leading: const Icon(Icons.folder_open_rounded),
                title: Text(_displayName(directory)),
                subtitle: Text(directory.path),
                onTap: () => _openDirectory(directory),
              ),
            for (final image in _images)
              ListTile(
                leading: _ImageThumbnail(path: image.path),
                title: Text(_displayName(image)),
                subtitle: Text(image.path),
                onTap: () => context.pop(image.path),
              ),
            if (_directories.isEmpty && _images.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  context.tr(
                    'No hay imágenes compatibles en esta carpeta.',
                    'There are no supported images in this folder.',
                  ),
                  style: TextStyle(color: palette.textSecondary),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Directory? _parentOf(Directory? directory) {
    if (directory == null) {
      return null;
    }

    final parent = directory.parent;
    if (parent.path == directory.path || !parent.existsSync()) {
      return null;
    }

    return parent;
  }

  String _displayName(FileSystemEntity entity) {
    final normalized = entity.path.replaceAll(r'\', '/');
    final trimmed = normalized.endsWith('/')
        ? normalized.substring(0, normalized.length - 1)
        : normalized;
    final slash = trimmed.lastIndexOf('/');

    if (slash < 0 || slash == trimmed.length - 1) {
      return entity.path;
    }

    return trimmed.substring(slash + 1);
  }

  String _extension(String path) {
    final name = _displayName(File(path)).toLowerCase();
    final dot = name.lastIndexOf('.');
    return dot < 0 ? '' : name.substring(dot);
  }
}

class _ImageThumbnail extends StatelessWidget {
  const _ImageThumbnail({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.file(
        File(path),
        width: 42,
        height: 42,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox.square(
            dimension: 42,
            child: Icon(Icons.image_not_supported_outlined),
          );
        },
      ),
    );
  }
}
