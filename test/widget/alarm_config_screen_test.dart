import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/alarm/presentation/alarm_config_screen.dart';
import '../helpers/l10n_test_helper.dart';

void main() {
  testWidgets('Alarm config shows destination required when empty', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: buildL10nTestApp(const AlarmConfigScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No destination selected'), findsOneWidget);
    expect(find.text('Search destination'), findsOneWidget);
  });
}
