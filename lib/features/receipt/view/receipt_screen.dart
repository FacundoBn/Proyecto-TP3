import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../models/ticket.dart';

class ReceiptScreen extends StatelessWidget {
  final TicketView ticket;
  const ReceiptScreen({super.key, required this.ticket});

  String _payload() {
    return '{"id":"${ticket.id}","patente":"${ticket.patente}","monto":${ticket.precioFinal ?? 0},"estado":"${ticket.egreso == null ? 'abierto' : 'cerrado'}"}';
    // esto es demo; después lo podés firmar/hashear
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Comprobante',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Ticket #${ticket.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(ticket.egreso == null ? 'Estado: Abierto' : 'Estado: Cerrado'),
                  const SizedBox(height: 12),
                  QrImageView(data: _payload(), version: QrVersions.auto, size: 220),
                  const SizedBox(height: 12),
                  const Divider(),
                  _row('Patente', ticket.patente),
                  _row('Slot', ticket.slotId),
                  _row('Ingreso', ticket.ingreso.toLocal().toString()),
                  _row('Egreso', ticket.egreso?.toLocal().toString() ?? '-'),
                  _row('Total', ticket.precioFinal?.toStringAsFixed(2) ?? '-'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(width: 100, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
            Expanded(child: Text(v)),
          ],
        ),
      );
}
