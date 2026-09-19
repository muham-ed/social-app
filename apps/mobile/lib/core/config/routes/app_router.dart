import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/short_video/presentation/pages/create_video_page.dart';
import '../../../features/audio_video_rooms/presentation/pages/create_room_page.dart';
import '../../demo_app.dart';

class AppRouter {
  static GoRouter router(BuildContext context) {
    return GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(path: '/splash', builder: (_, __) => const DemoApp()),
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(path: '/create-video', builder: (_, __) => const CreateVideoPage()),
        GoRoute(path: '/create-room', builder: (_, __) => const CreateRoomPage()),
      ],
    );
  }
}
