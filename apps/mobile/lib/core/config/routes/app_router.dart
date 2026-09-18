import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/auth/presentation/pages/register_page.dart';
import '../../../features/auth/presentation/pages/splash_page.dart';
import '../../../features/short_video/presentation/pages/home_page.dart';
import '../../../features/audio_video_rooms/presentation/pages/rooms_page.dart';
import '../../../features/direct_messaging/presentation/pages/conversations_page.dart';
import '../../../features/location_discovery/presentation/pages/discover_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/notifications/presentation/pages/notifications_page.dart';
import '../../../core/widgets/main_shell.dart';

class AppRouter {
  static GoRouter router(BuildContext context) {
    return GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomePage()),
            GoRoute(path: '/rooms', builder: (_, __) => const RoomsPage()),
            GoRoute(path: '/discover', builder: (_, __) => const DiscoverPage()),
            GoRoute(path: '/messages', builder: (_, __) => const ConversationsPage()),
            GoRoute(path: '/notifications', builder: (_, __) => const NotificationsPage()),
            GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
          ],
        ),
      ],
    );
  }
}