import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../data/home/state/tickets_provider.dart';
import '../../../models/ticket.dart';

class ActiveSessionScreen extends StatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  Timer? _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final t = context.read<TicketsProvider>().currentActive;
      if (t == null) return;
      final now = DateTime.now().toUtc();
      setState(() {
        _elapsed = now.difference(t.ingreso);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TicketsProvider>();
    final TicketView? t = prov.currentActive;

    return AppScaffold(
      title: 'Estadía activa',
      body: t == null
          ? const Center(child: Text('No hay ninguna estadía activa.'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.withOpacity(.15),
                        child: const Icon(Icons.local_parking, color: Colors.orange),
                      ),
                      title: Text('Patente: ${t.patente}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('Inicio: ${t.ingreso.toLocal()} • Slot: ${t.slotId}'),
                      trailing: const Chip(label: Text('Activo')),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ElapsedBox(elapsed: _elapsed),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () {
                      // Cierra y obtiene el ticket actualizado
                      final updated = prov.finishSession(t.id, ratePerHour: 100);
                      if (updated != null && context.mounted) {
                        // Redirige al detalle del ticket ya cerrado
                        context.go('/ticket', extra: updated);
                      }
                    },
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: const Text('Finalizar'),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ElapsedBox extends StatelessWidget {
  final Duration elapsed;
  const _ElapsedBox({required this.elapsed});

  @override
  Widget build(BuildContext context) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = two(elapsed.inHours);
    final m = two(elapsed.inMinutes.remainder(60));
    final s = two(elapsed.inSeconds.remainder(60));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Tiempo transcurrido', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text('$h:$m:$s', style: Theme.of(context).textTheme.displaySmall),
          ],
        ),
      ),
    );
  }
}
