import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/unified_login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SihFrontendApp());
}

class SihFrontendApp extends StatelessWidget {
  const SihFrontendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nenil - Senior Cognitive Care',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const UnifiedLoginScreen(),
    );
  }
}
