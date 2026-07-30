import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/shared/widgets/settings_controls.dart';
import '../helpers/l10n_test_helper.dart';

enum _TestOption { a, b, c }

void main() {
  testWidgets('SettingsPickerTile opens sheet and returns selection', (tester) async {
    _TestOption? selected;

    await tester.pumpWidget(
      buildL10nTestApp(
        Scaffold(
          body: Builder(
            builder: (context) => SettingsPickerTile(
              title: 'Theme',
              valueLabel: 'System',
              onTap: () async {
                selected = await showSettingsPickerSheet<_TestOption>(
                  context: context,
                  title: 'Theme',
                  options: _TestOption.values,
                  value: _TestOption.a,
                  labelFor: (o) => o.name,
                  cancelLabel: 'Cancel',
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();

    expect(find.text('a'), findsOneWidget);
    expect(find.text('b'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.text('b'));
    await tester.pumpAndSettle();

    expect(selected, _TestOption.b);
  });

  testWidgets('Cancel dismisses sheet without selection', (tester) async {
    _TestOption? selected = _TestOption.a;

    await tester.pumpWidget(
      buildL10nTestApp(
        Scaffold(
          body: Builder(
            builder: (context) => SettingsPickerTile(
              title: 'Language',
              valueLabel: 'English',
              onTap: () async {
                selected = await showSettingsPickerSheet<_TestOption>(
                  context: context,
                  title: 'Language',
                  options: _TestOption.values,
                  value: _TestOption.a,
                  labelFor: (o) => o.name,
                  cancelLabel: 'Cancel',
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(selected, isNull);
  });

  testWidgets('SettingsSegmentedControl changes value', (tester) async {
    var value = true;

    await tester.pumpWidget(
      buildL10nTestApp(
        Scaffold(
          body: SettingsSegmentedControl<bool>(
            options: const [true, false],
            value: value,
            labelFor: (v) => v ? 'Kilometers' : 'Miles',
            onChanged: (v) => value = v,
          ),
        ),
      ),
    );

    expect(find.text('Kilometers'), findsOneWidget);
    expect(find.text('Miles'), findsOneWidget);

    await tester.tap(find.text('Miles'));
    await tester.pumpAndSettle();

    expect(value, isFalse);
  });
}
