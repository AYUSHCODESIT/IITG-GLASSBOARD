import 'package:flutter/material.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String moduleDetails = '/module-details';
  static const String createHandshake = '/create-handshake';
  static const String viewHandshakes = '/view-handshakes';
  static const String auditLogs = '/audit-logs';
  static const String admin = '/admin';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Dynamic routes will be resolved directly or fall back
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
