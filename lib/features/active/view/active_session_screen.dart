import 'package:flutter/material.dart';
import '../../../core/widgets/app_scaffold.dart';

class ActiveSessionScreen extends StatelessWidget {
  const ActiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Estadía activa',
      body: Center(child: Text('ActiveSessionScreen (placeholder)')),
    );
  }
}
