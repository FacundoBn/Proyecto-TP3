import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../data/home/state/tickets_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _selectedPlate;

  @override
  Widget build(BuildContext context) {
    final ticketsProv = context.watch<TicketsProvider>();
    final plates = ticketsProv.vehicles.map((v) => v.numero).toList();

    return AppScaffold(
      title: 'Historial',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona una patente:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              hint: const Text('Elige una patente'),
              value: _selectedPlate,
              items: plates.map((plate) {
                return DropdownMenuItem<String>(
                  value: plate,
                  child: Text(plate),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedPlate = value);
                if (value != null) {
                  context.go('/history/$value');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
