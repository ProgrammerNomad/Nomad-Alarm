import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/features/splash/presentation/splash_screen.dart';
import 'package:nomad_alarm/shared/widgets/nomad_logo.dart';
import '../helpers/l10n_test_helper.dart';

void main() {
  testWidgets('Splash screen shows logo', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: buildL10nTestApp(const SplashScreen()),
      ),
    );
    await tester.pump();
    expect(find.byType(NomadLogo), findsOneWidget);
  });
}
