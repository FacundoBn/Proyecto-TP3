import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../models/ticket.dart';

class TicketDetailScreen extends StatelessWidget {
  final TicketView ticket;
  const TicketDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final estado = ticket.egreso == null ? 'Activo' : 'Cerrado';
    final color = ticket.egreso == null ? Colors.orange : Colors.green;

    return AppScaffold(
      title: 'Detalle de ticket',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(.15),
                child: Icon(ticket.egreso == null ? Icons.local_parking : Icons.receipt_long, color: color),
              ),
              title: Text('Patente: ${ticket.patente}', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('Estado: $estado'),
              trailing: Chip(label: Text(estado)),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _row('ID ticket', ticket.id),
                  const Divider(height: 20),
                  _row('Slot', ticket.slotId),
                  _row('Usuario', ticket.userId),
                  _row('Invitado', ticket.guestId ?? '-'),
                  const Divider(height: 20),
                  _row('Ingreso', ticket.ingreso.toLocal().toString()),
                  _row('Egreso', ticket.egreso?.toLocal().toString() ?? '-'),
                  const Divider(height: 20),
                  _row('Total', ticket.precioFinal?.toStringAsFixed(2) ?? '-'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => context.go('/receipt', extra: ticket),
            icon: const Icon(Icons.receipt_long),
            label: const Text('Ver comprobante'),
          ),
        ],
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}
