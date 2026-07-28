import 'package:flutter/material.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NomadScaffold(
      title: 'Privacy',
      showBackButton: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your privacy matters',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('• No account or login required'),
            SizedBox(height: 8),
            Text('• No ads or analytics'),
            SizedBox(height: 8),
            Text('• No cloud storage - all data stays on your device'),
            SizedBox(height: 8),
            Text('• Location is used only for alarm distance calculation'),
            SizedBox(height: 8),
            Text('• Open source - inspect the code anytime'),
          ],
        ),
      ),
    );
  }
}
