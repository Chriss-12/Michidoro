import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_app_v1/app/theme/app_card_paddings.dart';
import 'package:pomodoro_app_v1/app/theme/app_theme.dart';

class DirectoryPickerPage extends StatefulWidget {
  const DirectoryPickerPage({super.key, this.initialPath});

  static const routePath = '/settings/directory-picker';

  final String? initialPath;

  @override
  State<DirectoryPickerPage> createState() => _DirectoryPickerPageState();
}

class _DirectoryPickerPageState extends State<DirectoryPickerPage> {
  Directory? _currentDirectory;
  List<Directory> _roots = const [];
  List<Directory> _children = const [];
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
    final initialDirectory = initialPath != null && initialPath.isNotEmpty
        ? Directory(initialPath)
        : roots.firstOrNull;

    setState(() {
      _roots = roots;
    });

    await _openDirectory(
      initialDirectory != null && initialDirectory.existsSync()
          ? initialDirectory
          : roots.firstOrNull,
    );
  }

  Future<void> _openDirectory(Directory? directory) async {
    if (directory == null) {
      setState(() {
        _currentDirectory = null;
        _children = const [];
        _errorMessage = 'No se encontraron carpetas accesibles.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final children =
          directory
              .listSync()
              .whereType<Directory>()
              .where((child) => !_isHidden(child))
              .toList()
            ..sort(
              (first, second) => first.path.toLowerCase().compareTo(
                second.path.toLowerCase(),
              ),
            );

      setState(() {
        _currentDirectory = directory;
        _children = children;
        _isLoading = false;
      });
    } on FileSystemException {
      setState(() {
        _currentDirectory = directory;
        _children = const [];
        _errorMessage = 'No se pudo leer esta carpeta.';
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
      await addIfExists(Directory('/storage/emulated/0/Download'));
      await addIfExists(Directory('/storage/emulated/0'));
    } else if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      if (userProfile != null && userProfile.trim().isNotEmpty) {
        await addIfExists(Directory('$userProfile\\Downloads'));
        await addIfExists(Directory(userProfile));
      }
      for (var code = 67; code <= 90; code++) {
        await addIfExists(Directory('${String.fromCharCode(code)}:\\'));
      }
    } else {
      final home = Platform.environment['HOME'];
      if (home != null && home.trim().isNotEmpty) {
        await addIfExists(Directory('$home/Downloads'));
        await addIfExists(Directory(home));
      }
      await addIfExists(Directory('/'));
    }

    return roots;
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
        title: const Text('Seleccionar carpeta'),
        actions: [
          TextButton(
            onPressed: currentDirectory == null
                ? null
                : () => context.pop(currentDirectory.path),
            child: const Text('Elegir'),
          ),
        ],
      ),
      body: ListView(
        padding: AppCardPaddings.page,
        children: [
          Text(
            currentDirectory?.path ?? 'Sin carpeta seleccionada',
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
              title: const Text('Subir carpeta'),
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
          else
            for (final child in _children)
              ListTile(
                leading: const Icon(Icons.folder_open_rounded),
                title: Text(_displayName(child)),
                subtitle: Text(child.path),
                onTap: () => _openDirectory(child),
              ),
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

  String _displayName(Directory directory) {
    final normalized = directory.path.replaceAll(r'\', '/');
    final trimmed = normalized.endsWith('/')
        ? normalized.substring(0, normalized.length - 1)
        : normalized;
    final slash = trimmed.lastIndexOf('/');

    if (slash < 0 || slash == trimmed.length - 1) {
      return directory.path;
    }

    return trimmed.substring(slash + 1);
  }
}
