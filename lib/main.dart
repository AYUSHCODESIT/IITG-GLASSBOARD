import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'features/auth/presentation/screens/auth_screens.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Dual-mode Adapter (Live Firebase vs. High-fidelity Mock repository)
  final firebaseService = FirebaseService();
  await firebaseService.initialize();

  runApp(
    const ProviderScope(
      child: GlassBoardApp(),
    ),
  );
}

class GlassBoardApp extends StatelessWidget {
  const GlassBoardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlassBoard',
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration (Tailwind tail-colored Light / Glassmorphic Dark modes)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to gorgeous dark mode!

      // Named route configurations
      initialRoute: AppRouter.splash,
      routes: {
        AppRouter.splash: (context) => const SplashScreen(),
        AppRouter.login: (context) => const LoginScreen(),
        AppRouter.register: (context) => const RegisterScreen(),
        AppRouter.forgotPassword: (context) => const ForgotPasswordScreen(),
        AppRouter.dashboard: (context) => const DashboardScreen(),
      },
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
