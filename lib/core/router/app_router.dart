import 'package:go_router/go_router.dart';
import 'package:tp_final_componentes/presentation/screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: "/home",
  routes: 
  [GoRoute(path: '/home',
  builder:(context, state) => HomeScreen())]
);