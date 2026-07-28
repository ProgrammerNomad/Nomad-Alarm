import 'package:flutter/material.dart';
import 'package:nomad_alarm/core/constants/ui_constants.dart';

class NomadScaffold extends StatelessWidget {
  const NomadScaffold({
    required this.title,
    required this.body,
    super.key,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBackButton,
        actions: actions,
      ),
      body: Padding(
        padding: const EdgeInsets.all(UiConstants.screenPadding),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
