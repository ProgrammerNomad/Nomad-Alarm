import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/features/alarm/presentation/import_alarm_flow.dart';

class ImportQrScanScreen extends StatefulWidget {
  const ImportQrScanScreen({super.key});

  @override
  State<ImportQrScanScreen> createState() => _ImportQrScanScreenState();
}

class _ImportQrScanScreenState extends State<ImportQrScanScreen> {
  bool _handled = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handled) {
      return;
    }
    final raw = capture.barcodes.firstOrNull?.rawValue?.trim();
    if (raw == null || raw.isEmpty) {
      return;
    }
    _handled = true;
    if (!mounted) {
      return;
    }
    await ImportAlarmFlow.decodeRawAndPreview(context, raw);
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.importSourceQr),
      ),
      body: MobileScanner(
        onDetect: _onDetect,
      ),
    );
  }
}
