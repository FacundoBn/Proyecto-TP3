import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../data/home/state/tickets_provider.dart';
import '../../../data/auth/state/profile_provider.dart';
import '../../../data/auth/state/auth_provider.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  String language = 'Español';

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = context.read<ProfileProvider>();
    if (!profile.loading && profile.email.isEmpty && profile.name.isEmpty) {
      profile.load();
    }
    _emailCtrl.text = profile.email;
    _passCtrl.text = profile.password;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<String?> _promptPatente(BuildContext context, {String? initial}) async {
    final controller = TextEditingController(text: initial ?? '');
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(initial == null ? 'Agregar patente' : 'Editar patente'),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Patente',
            hintText: 'Ej: AB123CD',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim().toUpperCase()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirm(BuildContext context, String msg) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sí')),
        ],
      ),
    );
    return res == true;
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TicketsProvider>();
    final vehicles = prov.vehicles;
    final profile = context.watch<ProfileProvider>();

    return AppScaffold(
      title: 'Ajustes',
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Agregar patente'),
        onPressed: () async {
          final nueva = await _promptPatente(context);
          if (nueva != null && nueva.isNotEmpty) {
            await context.read<TicketsProvider>().addVehicle(nueva);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Patente $nueva agregada')),
              );
            }
          }
        },
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            subtitle: const Text('Datos de tu cuenta'),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: TextEditingController(text: profile.name),
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),

                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Guardar cambios'),
                      onPressed: () async {
                        await context.read<ProfileProvider>().updateEmailPassword(
                          email: _emailCtrl.text.trim(),
                          password: _passCtrl.text,
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Perfil actualizado')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Patentes registradas'),
            subtitle: vehicles.isEmpty ? const Text('No hay vehículos registrados') : null,
          ),
          if (vehicles.isNotEmpty)
            ...vehicles.map(
                  (v) => Card(
                child: ListTile(
                  title: Text(v.patente),
                  subtitle: Text('ID: ${v.id}'),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        tooltip: 'Editar',
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final nuevo = await _promptPatente(context, initial: v.patente);
                          if (nuevo != null && nuevo.isNotEmpty && nuevo != v.patente) {
                            await context
                                .read<TicketsProvider>()
                                .renameVehicle(id: v.id, newPatente: nuevo);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Patente actualizada a $nuevo')),
                              );
                            }
                          }
                        },
                      ),
                      IconButton(
                        tooltip: 'Eliminar',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          final ok = await _confirm(
                            context,
                            '¿Eliminar la patente ${v.patente}? Esta acción no se puede deshacer.',
                          );
                          if (ok) {
                            await context.read<TicketsProvider>().deleteVehicle(v.id);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Patente ${v.patente} eliminada')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const Divider(height: 32),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              await context.read<AuthProvider>().logout();

              if (!mounted) return;

              context.go('/login');

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sesión cerrada')),
              );
            },
          ),

        ],
      ),
    );
  }
}
