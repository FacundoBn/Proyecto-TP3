import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../models/ticket.dart';
import '../../../data/home/state/tickets_provider.dart';

class VehicleHistoryScreen extends StatelessWidget {
  final String plate;
  const VehicleHistoryScreen({super.key, required this.plate});

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '-';
    final l = dt.toLocal();
    final two = (int n) => n.toString().padLeft(2, '0');
    return '${l.year}-${two(l.month)}-${two(l.day)} ${two(l.hour)}:${two(l.minute)}';
  }

  String _fmtAmount(num? n) => n == null ? '-' : n.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final ticketsProv = context.watch<TicketsProvider>();
    final target = plate.toUpperCase();

    final closedTickets = ticketsProv.items
        .where((t) => t.patente.toUpperCase() == target && t.egreso != null)
        .toList()
      ..sort((a, b) {
        final ae = a.egreso ?? a.ingreso;
        final be = b.egreso ?? b.ingreso;
        return be.compareTo(ae);
      });

    final body = ticketsProv.loading
        ? const Center(child: CircularProgressIndicator())
        : closedTickets.isEmpty
        ? const Center(child: Text('No hay comprobantes para esta patente'))
        : ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: closedTickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final t = closedTickets[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.withOpacity(.12),
              child: const Icon(Icons.receipt_long, color: Colors.green),
            ),
            title: Text('Comprobante ${t.id}'),
            subtitle: Text(
              'Ingreso: ${_fmtDate(t.ingreso)}\n'
                  'Egreso: ${_fmtDate(t.egreso)}\n'
                  'Monto: \$${_fmtAmount(t.precioFinal)}',
            ),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/receipt', extra: t),
          ),
        );
      },
    );

    return AppScaffold(
      title: 'Historial $plate',
      actions: [
        IconButton(
          tooltip: 'Actualizar',
          onPressed: () => context.read<TicketsProvider>().load(),
          icon: const Icon(Icons.refresh),
        ),
      ],
      body: RefreshIndicator(
        onRefresh: () => context.read<TicketsProvider>().load(),
        child: body,
      ),
    );
  }
}
