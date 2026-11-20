import 'package:card_insiderapp/screens/dashboard_screen.dart';
import 'package:card_insiderapp/screens/profile_screen.dart';
import 'package:card_insiderapp/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/Splash',
  routes: [
    GoRoute(path: '/Splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/Dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
