import 'package:flutter/material.dart';
import '../../../core/widgets/app_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Ajustes',
      body: Center(child: Text('SettingsScreen (placeholder)')),
    );
  }
}
