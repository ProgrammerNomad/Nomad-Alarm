import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Registers Isar native libs with the Flutter engine.
// ignore: unused_import
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:nomad_alarm/app.dart';
import 'package:nomad_alarm/services/google_maps_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleMapsInit.applyFromStore();
  runApp(
    const ProviderScope(
      child: NomadAlarmApp(),
    ),
  );
}
