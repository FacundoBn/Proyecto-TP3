import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../../../data/home/state/tickets_provider.dart';
import '../../../models/vehicle.dart';
import '../../../utils/plate.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TicketsProvider>();
    final vehicles = prov.vehicles;

    return AppScaffold(
      title: 'Ajustes',
      actions: [
        IconButton(
          tooltip: 'Recargar',
          onPressed: () => context.read<TicketsProvider>().load(),
          icon: const Icon(Icons.refresh),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle('Mis vehículos'),
          const SizedBox(height: 8),

          // Lista de patentes guardadas
          if (vehicles.isEmpty)
            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Todavía no agregaste patentes'),
                subtitle: const Text('Usá el botón de abajo para registrar una.'),
              ),
            )
          else
            ...vehicles.map((v) => _VehicleTile(v: v)).toList(),

          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              final nuevaPatente = await _promptPatente(context);
              if (nuevaPatente == null || nuevaPatente.isEmpty) return;

              final normalized = PlateValidator.normalize(nuevaPatente);
              if (!PlateValidator.isValid(normalized)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Patente inválida. Formatos: ABC123 o AB123CD')),
                );
                return;
              }

              final veh = Vehicle(
                id: const Uuid().v4(),
                numero: normalized,
                usuarioId: 'u1', // TODO: reemplazar con el ID real del usuario logueado
              );

              await context.read<TicketsProvider>().addVehicle(veh);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Patente ${veh.numero} agregada')),
                );
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Agregar vehículo'),
          ),

          const SizedBox(height: 32),
          const _SectionTitle('Preferencias'),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile.adaptive(
              value: true,
              onChanged: (_) {},
              title: const Text('Notificaciones de vencimiento'),
              subtitle: const Text('Avisarme cuando esté por finalizar una estadía'),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleTile extends StatelessWidget {
  final Vehicle v;
  const _VehicleTile({required this.v});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.directions_car),
        title: Text(v.numero, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('ID: ${v.id} • Usuario: ${v.usuarioId}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            switch (value) {
              case 'rename':
                final nuevo = await _promptPatente(context, initial: v.numero);
                if (nuevo == null || nuevo.isEmpty) return;

                final normalized = PlateValidator.normalize(nuevo);
                if (!PlateValidator.isValid(normalized)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Patente inválida. Formatos: ABC123 o AB123CD')),
                  );
                  return;
                }

                await context
                    .read<TicketsProvider>()
                    .renameVehicle(id: v.id, newPatente: normalized);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Patente actualizada a $normalized')),
                  );
                }
                break;

              case 'delete':
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Confirmar eliminación'),
                    content: Text('¿Eliminar la patente ${v.numero}? Esta acción no se puede deshacer.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                      FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
                    ],
                  ),
                );

                if (ok == true) {
                  await context.read<TicketsProvider>().deleteVehicle(v.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Patente ${v.numero} eliminada')),
                    );
                  }
                }
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'rename', child: Text('Renombrar')),
            PopupMenuItem(value: 'delete', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700));
  }
}

/// Dialog para pedir una patente
Future<String?> _promptPatente(BuildContext context, {String? initial}) async {
  final ctrl = TextEditingController(text: initial ?? '');
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Patente'),
      content: TextField(
        controller: ctrl,
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(
          hintText: 'AB123CD o ABC123',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(onPressed: () => Navigator.pop(context, ctrl.text.trim()), child: const Text('Aceptar')),
      ],
    ),
  );
}
