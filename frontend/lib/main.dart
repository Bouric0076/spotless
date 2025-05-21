import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

import 'views/auth/login_view.dart';
import 'views/auth/register_view.dart';
import 'views/home/customer_dashboard.dart';
import 'views/auth/customer_registration_view.dart';
import 'views/auth/forgot_password_view.dart';
import 'views/auth/reset_password_view.dart';

void main() {
  runApp(const SpotlessApp());
}

class SpotlessApp extends StatefulWidget {
  const SpotlessApp({super.key});

  @override
  State<SpotlessApp> createState() => _SpotlessAppState();
}

class _SpotlessAppState extends State<SpotlessApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    try {
      // Get initial link as Uri? from app_links package
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _processUri(initialUri);
      }

      // Listen for incoming deep links
      _sub = _appLinks.uriLinkStream.listen((Uri uri) {
        _processUri(uri);
      }, onError: (err) {
        debugPrint('Error receiving deep link: $err');
      });
    } catch (e) {
      debugPrint('Failed to initialize app links: $e');
    }
  }

  void _processUri(Uri uri) {
    debugPrint('Received URI: $uri');

    if (uri.path == '/reset-password') {
      final uid = uri.queryParameters['uid'];
      final token = uri.queryParameters['token'];

      if (uid != null && token != null) {
        _navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ResetPasswordView(uid: uid, token: token),
          ),
        );
      }
    } else {
      debugPrint('Unhandled URI path: ${uri.path}');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotless',
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/CustomerDashboard': (context) =>
            const CustomerDashboard(username: 'exampleUsername'),
        '/register-cleaner': (context) => const CleanerRegistrationView(),
        '/forgot-password': (context) => const ForgotPasswordView(),
      },
      onGenerateRoute: (settings) {
        Uri uri = Uri.parse(settings.name ?? '');

        if (uri.path == '/reset-password') {
          final uid = uri.queryParameters['uid'];
          final token = uri.queryParameters['token'];

          if (uid != null && token != null) {
            return MaterialPageRoute(
              builder: (_) => ResetPasswordView(uid: uid, token: token),
            );
          }
        }

        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
      },
    );
  }
}
