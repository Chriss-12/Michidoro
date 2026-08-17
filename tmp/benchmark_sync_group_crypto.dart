import 'package:flutter/material.dart';
import 'package:pomodoro_app_v1/features/sync/data/services/sync_group_crypto.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _BenchmarkApp());
}

class _BenchmarkApp extends StatefulWidget {
  const _BenchmarkApp();

  @override
  State<_BenchmarkApp> createState() => _BenchmarkAppState();
}

class _BenchmarkAppState extends State<_BenchmarkApp> {
  String _result = 'Midiendo Argon2id…';

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    const password = 'physical benchmark password only';
    const groupId = 'group_0123456789abcdef0123456789abcdef';
    final crypto = SyncGroupCrypto();
    final createWatch = Stopwatch()..start();
    final created = await crypto.createGroupKeys(
      groupId: groupId,
      password: password,
    );
    createWatch.stop();
    final unlockWatch = Stopwatch()..start();
    final key = await crypto.unlockWithPassword(created.manifest, password);
    final clear = List<int>.from(await key.extractBytes());
    unlockWatch.stop();
    clear.fillRange(0, clear.length, 0);
    final message = 'MICHIFOCUS_ARGON2 create_ms=${createWatch.elapsedMilliseconds} '
        'unlock_ms=${unlockWatch.elapsedMilliseconds}';
    debugPrint(message);
    if (mounted) setState(() => _result = message);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_result, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
