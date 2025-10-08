import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/auth/state/auth_provider.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final email = context.read<AuthProvider>().email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
        // 👇 FIX: usar Builder para obtener un context con acceso al Scaffold
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
                tooltip: 'Volver',
              )
            : Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                  tooltip: 'Menú',
                ),
              ),
        actions: actions,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (email.isNotEmpty)
                UserAccountsDrawerHeader(
                  accountName: const Text('Sesión iniciada'),
                  accountEmail: Text(email),
                  currentAccountPicture: const CircleAvatar(child: Icon(Icons.person)),
                ),
              _tile(context, Icons.home,      'Home',            '/home'),
              _tile(context, Icons.qr_code,   'Escanear',        '/scan'),
              _tile(context, Icons.timer,     'Estadía activa',  '/active'),
              _tile(context, Icons.receipt,   'Resumen',         '/summary'),
              _tile(context, Icons.confirmation_number, 'Comprobante', '/receipt'),
              _tile(context, Icons.history,   'Historial',       '/history'),
              _tile(context, Icons.settings,  'Ajustes',         '/settings'),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Salir'),
                onTap: () async {
                  Navigator.pop(context);
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          ),
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }

  ListTile _tile(BuildContext context, IconData icon, String label, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pop(context); // cerrar drawer
        context.go(route);
      },
    );
  }
}
