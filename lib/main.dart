import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

import 'data/auth/state/auth_provider.dart';
import 'data/auth/data/auth_repository.dart';

import 'features/pricing/state/pricing_provider.dart';
import 'features/parking/state/parking_provider.dart';
import 'services/storage_service.dart';

import 'data/home/state/tickets_provider.dart';
import 'data/auth/state/profile_provider.dart'; // ✅ import nuevo
import 'infra/hardcode_connection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StorageService();
    final authRepo = AuthRepository();
    final conn = HardcodeConnection();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepo)..init()),
        ChangeNotifierProvider(create: (_) => PricingProvider(store)..init()),
        ChangeNotifierProvider(
          create: (ctx) => ParkingProvider(store, ctx.read<PricingProvider>())..init(),
        ),
        ChangeNotifierProvider(create: (_) => TicketsProvider(conn)..load()),

        ChangeNotifierProvider(create: (_) => ProfileProvider(conn)..load()),
      ],
      child: Builder(
        builder: (context) {
          final auth = context.watch<AuthProvider>();
          final router = AppRouter.build(auth);
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Control de Estacionamiento',
            theme: AppTheme.light,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
