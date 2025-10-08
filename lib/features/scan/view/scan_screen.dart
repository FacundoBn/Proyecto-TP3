import 'package:flutter/material.dart';
import '../../../core/widgets/app_scaffold.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Escanear patente',
      body: const Center(child: Text('ScanScreen (placeholder)')),
    );
  }
}
