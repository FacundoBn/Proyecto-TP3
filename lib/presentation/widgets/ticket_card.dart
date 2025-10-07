import 'package:flutter/material.dart';
import 'package:tp_final_componentes/domain/models/ticket.dart';


class TicketCard extends StatelessWidget {
  final Ticket ticket;

  const TicketCard({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final estado = ticket.egreso == null ? 'Abierto' : 'Cerrado';
    final estadoColor = ticket.egreso == null ? theme.colorScheme.primary : theme.disabledColor;

    final ingresoStr =
        "${ticket.ingreso.hour.toString().padLeft(2, '0')}:${ticket.ingreso.minute.toString().padLeft(2, '0')}";
    final egresoStr = ticket.egreso != null
        ? "${ticket.egreso!.hour.toString().padLeft(2, '0')}:${ticket.egreso!.minute.toString().padLeft(2, '0')}"
        : "--:--";
    final duracionStr = ticket.egreso != null
        ? "${ticket.duracion.inHours}h ${ticket.duracion.inMinutes % 60}m"
        : "--:--";

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primera fila: Estado y Slot
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Estado: $estado",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: estadoColor,
                  ),
                ),
                Text(
                  "Cochera: ${ticket.slotId}",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Segunda fila: Vehículo
            Text(
              "Vehículo: ${ticket.vehicleId}",
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            // Tercera fila: Horas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ingreso: $ingresoStr", style: theme.textTheme.bodySmall),
                Text("Egreso: $egresoStr", style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 4),
            Text("Duración: $duracionStr", style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            if (ticket.precioFinal != null)
              Text(
                "Precio final: \$${ticket.precioFinal!.toStringAsFixed(2)}",
                style: theme.textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}