import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../../../data/home/state/tickets_provider.dart';
import '../../../utils/plate.dart';
import 'widgets/plate_ocr_camera.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _startWithPlate(String plate) {
    final norm = PlateValidator.normalize(plate);
    if (!PlateValidator.isValid(norm)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patente inválida. Formatos: ABC123 o AB123CD')),
      );
      return;
    }
    context.read<TicketsProvider>().startSession(plate: norm);
    context.go('/active');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Escanear patente',
      body: Column(
        children: [
          const SizedBox(height: 8),
          TabBar(
            controller: _tab,
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(icon: Icon(Icons.photo_camera), text: 'Cámara (OCR)'),
              Tab(icon: Icon(Icons.keyboard_alt_outlined), text: 'Manual'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                // Cámara con OCR
                PlateOcrCamera(onPlateFound: _startWithPlate),

                // Manual
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: 'Patente',
                          hintText: 'AB123CD o ABC123',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => _startWithPlate(_controller.text),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Iniciar estadía'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => _controller.clear(),
                        icon: const Icon(Icons.clear),
                        label: const Text('Limpiar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
