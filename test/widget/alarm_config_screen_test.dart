import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/alarm/presentation/alarm_config_screen.dart';

void main() {
  testWidgets('Alarm config shows destination required when empty', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AlarmConfigScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No destination selected'), findsOneWidget);
    expect(find.text('Search destination'), findsOneWidget);
  });
}
