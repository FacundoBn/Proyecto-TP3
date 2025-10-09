import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../data/home/state/tickets_provider.dart';

class ActiveSessionScreen extends StatelessWidget {
  const ActiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TicketsProvider>();

    if (prov.loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Estadía activa')),
        body: const Center(child: CircularProgressIndicator()),
        drawer: const _AppDrawer(),
      );
    }

    final t = prov.active;
    if (t == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Estadía activa')),
        body: const Center(child: Text('No tenés una estadía activa')),
        drawer: const _AppDrawer(),
      );
    }

    return Scaffold(
      drawer: const _AppDrawer(),
      appBar: AppBar(
        title: const Text('Estadía activa'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: () => context.read<TicketsProvider>().load(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange.withOpacity(.15),
                      child: const Icon(Icons.local_parking, color: Colors.orange),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Patente: ${t.patente}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    const Chip(label: Text('Activo')),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Ingreso: ${t.ingreso}'),
                Text('Slot: ${t.slotId}'),
                const SizedBox(height: 12),

                StreamBuilder<DateTime>(
                  stream: Stream<DateTime>.periodic(
                    const Duration(seconds: 1),
                        (_) => DateTime.now(),
                  ),
                  initialData: DateTime.now(),
                  builder: (_, snapshot) {
                    final now = snapshot.data ?? DateTime.now();
                    final diff = now.difference(t.ingreso);
                    final hh = diff.inHours.toString().padLeft(2, '0');
                    final mm = (diff.inMinutes % 60).toString().padLeft(2, '0');
                    final ss = (diff.inSeconds % 60).toString().padLeft(2, '0');
                    return Text(
                      'Tiempo transcurrido: $hh:$mm:$ss',
                      style: Theme.of(context).textTheme.titleMedium,
                    );
                  },
                ),

                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.go('/receipt', extra: t);
                        },
                        icon: const Icon(Icons.receipt_long),
                        label: const Text('Ver comprobante'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          // ToDo
                        },
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text('Finalizar estadía'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  void _goAndClose(BuildContext context, String path) {
    Navigator.of(context).pop();
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Sesión iniciada'),
            accountEmail: Text('admin@demo.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.indigo),
            ),
            decoration: BoxDecoration(color: Color(0xFF3F51B5)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => _goAndClose(context, '/Home'),
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: const Text('Escanear'),
            onTap: () => _goAndClose(context, '/scan'),
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Estadía activa'),
            onTap: () => _goAndClose(context, '/active'),
          ),
          ListTile(
            leading: const Icon(Icons.summarize),
            title: const Text('Resumen'),
            onTap: () => _goAndClose(context, '/summary'),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Comprobante'),
            onTap: () => _goAndClose(context, '/receipt'),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historial'),
            onTap: () => _goAndClose(context, '/history'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ajustes'),
            onTap: () => _goAndClose(context, '/settings'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Salir'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
