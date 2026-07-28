import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/features/about/presentation/about_screen.dart';
import 'package:nomad_alarm/features/history/presentation/history_screen.dart';
import 'package:nomad_alarm/features/home/presentation/home_screen.dart';
import 'package:nomad_alarm/features/permission/presentation/permissions_screen.dart';
import 'package:nomad_alarm/features/privacy/presentation/privacy_screen.dart';
import 'package:nomad_alarm/features/settings/presentation/permission_center_screen.dart';
import 'package:nomad_alarm/features/settings/presentation/settings_screen.dart';
import 'package:nomad_alarm/features/splash/presentation/splash_screen.dart';
import 'package:nomad_alarm/features/trip/presentation/trips_screen.dart';
import 'package:nomad_alarm/features/welcome/presentation/welcome_screen.dart';
import 'package:nomad_alarm/shared/widgets/main_shell.dart';
import 'package:nomad_alarm/shared/widgets/placeholder_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/trips',
                builder: (context, state) => const TripsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings/permissions',
        builder: (context, state) => const PermissionCenterScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const PlaceholderScreen(title: 'Search'),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const PlaceholderScreen(title: 'Map'),
      ),
      GoRoute(
        path: '/alarm/new',
        builder: (context, state) => const PlaceholderScreen(title: 'Alarm Config'),
      ),
      GoRoute(
        path: '/alarm/active/:id',
        builder: (context, state) => PlaceholderScreen(
          title: 'Active Alarm #${state.pathParameters['id']}',
        ),
      ),
      GoRoute(
        path: '/alarm/ring/:id',
        builder: (context, state) => PlaceholderScreen(
          title: 'Alarm Ring #${state.pathParameters['id']}',
        ),
      ),
    ],
  );
});
