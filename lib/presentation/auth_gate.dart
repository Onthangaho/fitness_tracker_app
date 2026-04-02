import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/auth_provider.dart';
import 'landing_screen.dart';
import 'login_screen.dart';
import 'screens/home_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _validatedUserId;
  bool _isValidatingSession = false;
  bool _showAuthForm = false;
  bool _isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return StreamBuilder<Object?>(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            _isValidatingSession) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          _showAuthForm = false;
          final userId = authProvider.userId;
          if (userId != null && _validatedUserId != userId) {
            _validatedUserId = userId;
            _isValidatingSession = true;

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final messenger = ScaffoldMessenger.of(context);
              final message = await authProvider.validatePersistedSession();
              if (!mounted) {
                return;
              }

              setState(() {
                _isValidatingSession = false;
              });

              if (message != null) {
                messenger.showSnackBar(SnackBar(content: Text(message)));
              }
            });

            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return const HomeScreen();
        }

        _validatedUserId = null;
        if (!_showAuthForm) {
          return LandingScreen(
            onSignInTap: () {
              setState(() {
                _showAuthForm = true;
                _isLoginMode = true;
              });
            },
            onCreateAccountTap: () {
              setState(() {
                _showAuthForm = true;
                _isLoginMode = false;
              });
            },
          );
        }

        return LoginScreen(
          initialLoginMode: _isLoginMode,
          onBackToLanding: () {
            setState(() {
              _showAuthForm = false;
              _isLoginMode = true;
            });
          },
        );
      },
    );
  }
}
