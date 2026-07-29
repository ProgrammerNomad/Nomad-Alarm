import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:nomad_alarm/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: NomadAlarmApp(),
    ),
  );
}
