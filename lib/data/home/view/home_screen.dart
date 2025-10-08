import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/state/auth_provider.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthProvider>().email ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          if (email.isNotEmpty) Padding(padding: const EdgeInsets.only(right: 8), child: Center(child: Text(email, style: const TextStyle(fontSize: 12)))),
          IconButton(
            tooltip: 'Salir',
            icon: const Icon(Icons.logout),
            onPressed: () async { await context.read<AuthProvider>().logout(); if (context.mounted) context.go('/login'); },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Selección de zona (placeholder en ajustes)'),
          const SizedBox(height: 16),
          Wrap(spacing: 12, runSpacing: 12, children: [
            ElevatedButton.icon(onPressed: ()=>context.go('/scan'), icon: const Icon(Icons.qr_code_scanner), label: const Text('Escanear')),
            OutlinedButton.icon(onPressed: ()=>context.go('/history'), icon: const Icon(Icons.history), label: const Text('Historial')),
            FilledButton.icon(onPressed: ()=>context.go('/active'), icon: const Icon(Icons.timer), label: const Text('Estadía activa')),
            OutlinedButton.icon(onPressed: ()=>context.go('/settings'), icon: const Icon(Icons.settings), label: const Text('Ajustes')),
          ]),
        ]),
      ),
    );
  }
}
