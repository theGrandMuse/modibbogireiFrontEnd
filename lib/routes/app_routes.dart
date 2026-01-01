import 'package:modibbogirei/features/screens/responsive_screens/logout_screen.dart';
import 'package:modibbogirei/features/screens/responsive_screens/populating_screen.dart';
import 'package:go_router/go_router.dart';
import '../features/screens/pages/login.dart';
import '../features/screens/responsive_screens/dashboard_screen.dart';
import 'routes.dart';

class TAppRoute {
  
  static final goRoutes = [

    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(path: TRoutes.login, builder: (context, state) => const LoginScreen()),
    GoRoute(path: TRoutes.dashboard, builder: (context, state) => const ControlParametersScreen()),
    GoRoute(path: TRoutes.logout, builder: (context, state) => const LogoutScreen()),
    GoRoute(path: TRoutes.populationPage, builder: (context, state) => const PopulatingPage())
  ];
}
