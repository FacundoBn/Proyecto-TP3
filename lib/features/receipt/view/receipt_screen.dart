import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../models/ticket.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = GoRouterState.of(context).extra as TicketView?;

    if (t == null) {
      return const AppScaffold(
        title: 'Comprobante',
        body: Center(child: Text('No se encontró el comprobante')),
      );
    }

    final dur = (t.egreso ?? DateTime.now()).difference(t.ingreso);
    final hh = dur.inHours.toString().padLeft(2, '0');
    final mm = (dur.inMinutes % 60).toString().padLeft(2, '0');

    return AppScaffold(
      title: 'Comprobante',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Comprobante de Estacionamiento',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                _infoRow('Patente:', t.patente),
                _infoRow('Slot:', t.slotId),
                _infoRow('Ingreso:', t.ingreso.toString()),
                _infoRow('Egreso:', t.egreso?.toString() ?? '-'),
                _infoRow('Duración:', '$hh h $mm min'),
                _infoRow('Monto final:', t.precioFinal != null ? '\$${t.precioFinal}' : '-'),
                const Spacer(),
                Center(
                  child: FilledButton.icon(
                    onPressed: () => context.go('/Home'),
                    icon: const Icon(Icons.home),
                    label: const Text('Volver al inicio'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
