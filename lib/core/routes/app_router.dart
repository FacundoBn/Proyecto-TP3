import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../data/auth/view/login_screen.dart';
import '../../data/auth/view/register_screen.dart';
import '../../data/home/view/home_screen.dart';

import '../../features/scan/view/scan_screen.dart';
import '../../features/active/view/active_session_screen.dart';
import '../../features/summary/view/summary_screen.dart';
import '../../features/receipt/view/receipt_screen.dart';
import '../../features/history/view/history_screen.dart';
import '../../features/settings/view/settings_screen.dart';
import '../../features/tickets/view/ticket_detail_screen.dart';

import '../../data/auth/state/auth_provider.dart';
import '../../models/ticket.dart';

class AppRouter {
  static GoRouter build(AuthProvider auth) {
    bool isLogged() => auth.logged;

    return GoRouter(
      initialLocation: '/login',
      refreshListenable: auth,
      redirect: (context, state) {
        final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';
        if (!isLogged() && !loggingIn) return '/login';
        if (isLogged() && loggingIn) return '/home';
        return null;
      },
      routes: [
        GoRoute(path: '/login', pageBuilder: (c, s) => const NoTransitionPage(child: LoginScreen())),
        GoRoute(path: '/register', pageBuilder: (c, s) => const NoTransitionPage(child: RegisterScreen())),
        GoRoute(path: '/home', pageBuilder: (c, s) => const NoTransitionPage(child: HomeScreen())),
        GoRoute(path: '/scan', pageBuilder: (c, s) => const NoTransitionPage(child: ScanScreen())),
        GoRoute(path: '/active', pageBuilder: (c, s) => const NoTransitionPage(child: ActiveSessionScreen())),
        GoRoute(path: '/summary', pageBuilder: (c, s) => const NoTransitionPage(child: SummaryScreen())),
        GoRoute(path: '/history', pageBuilder: (c, s) => const NoTransitionPage(child: HistoryScreen())),
        GoRoute(path: '/settings', pageBuilder: (c, s) => const NoTransitionPage(child: SettingsScreen())),

        // Detalle de ticket (recibe TicketView por extra)
        GoRoute(
          path: '/ticket',
          pageBuilder: (c, s) {
            final ticket = s.extra as TicketView;
            return NoTransitionPage(child: TicketDetailScreen(ticket: ticket));
          },
        ),
        // Comprobante (recibe TicketView por extra)
        GoRoute(
          path: '/receipt',
          pageBuilder: (c, s) {
            final ticket = s.extra as TicketView;
            return NoTransitionPage(child: ReceiptScreen(ticket: ticket));
          },
        ),
      ],
    );
  }
}
