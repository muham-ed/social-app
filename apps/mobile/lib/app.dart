import 'package:flutter/material.dart';
import 'core/config/routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'تواصل',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF6C5CE7)),
      routerConfig: AppRouter.router(context),
    );
  }
}
