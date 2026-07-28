import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/app.dart';

void main() {
  testWidgets('App loads Nomad Alarm title', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: NomadAlarmApp(),
      ),
    );
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
