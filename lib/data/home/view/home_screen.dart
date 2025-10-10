import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../state/tickets_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketsProv = context.watch<TicketsProvider>();

    return AppScaffold(
      title: 'Home',
      actions: [
        IconButton(
          tooltip: 'Actualizar',
          onPressed: () => context.read<TicketsProvider>().load(),
          icon: const Icon(Icons.refresh),
        ),
      ],
      body: ticketsProv.loading
          ? const Center(child: CircularProgressIndicator())
          : ticketsProv.items.isEmpty
          ? const Center(child: Text('No hay tickets'))
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: ticketsProv.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final t = ticketsProv.items[i];
          final estado = t.activo ? 'Activo' : 'Finalizado';
          final color = t.activo ? Colors.orange : Colors.green;

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(.15),
                child: Icon(
                  t.activo ? Icons.local_parking : Icons.receipt_long,
                  color: color,
                ),
              ),
              title: Text('Patente: ${t.patente}'),
              subtitle: Text(
                'Ingreso: ${t.ingreso}'
                    '\nEgreso: ${t.egreso ?? '-'}'
                    '\nSlot: ${t.slotId}'
                    '\nMonto: ${t.precioFinal ?? '-'}',
              ),
              isThreeLine: true,
              trailing: Chip(label: Text(estado)),
              onTap: () {
                final prov = context.read<TicketsProvider>();

                if (t.activo) {
                  prov.setActive(t);
                  context.go('/active');
                } else {
                  context.go('/receipt', extra: t);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
