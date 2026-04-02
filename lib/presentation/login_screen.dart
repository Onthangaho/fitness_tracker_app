import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.initialLoginMode = true,
    this.onBackToLanding,
  });

  final bool initialLoginMode;
  final VoidCallback? onBackToLanding;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoginMode = true;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isLoginMode = widget.initialLoginMode;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthProvider authProvider) async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    bool success;
    if (_isLoginMode) {
      success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      success = await authProvider.register(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }

    if (!mounted || !success) {
      return;
    }
  }

  Future<void> _forgotPassword(AuthProvider authProvider) async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email first.')),
      );
      return;
    }

    final success = await authProvider.resetPassword(email);
    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent to $email.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFEBD2), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (widget.onBackToLanding != null) ...[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: widget.onBackToLanding,
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Back'),
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                              Row(
                                children: [
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3E0),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.lock_outline,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _isLoginMode
                                              ? 'Welcome Back'
                                              : 'Create Your Account',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        Text(
                                          _isLoginMode
                                              ? 'Sign in to continue your streak.'
                                              : 'Register to save your fitness progress.',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: const [
                                  Chip(label: Text('Secure Auth')),
                                  Chip(label: Text('Session Restore')),
                                ],
                              ),
                              const SizedBox(height: 18),
                              if (auth.hasError) ...[
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.red.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    auth.errorMessage ?? '',
                                    style: TextStyle(color: Colors.red.shade900),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (_) => auth.clearError(),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  final input = (value ?? '').trim();
                                  if (input.isEmpty) {
                                    return 'Email is required.';
                                  }
                                  if (!input.contains('@') ||
                                      !input.contains('.')) {
                                    return 'Enter a valid email address.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                onChanged: (_) => auth.clearError(),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  final input = value ?? '';
                                  if (input.isEmpty) {
                                    return 'Password is required.';
                                  }
                                  if (!_isLoginMode && input.length < 6) {
                                    return 'Password must be at least 6 characters.';
                                  }
                                  return null;
                                },
                              ),
                              if (!_isLoginMode) ...[
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Confirm Password',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if ((value ?? '').isEmpty) {
                                      return 'Please confirm your password.';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match.';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              if (_isLoginMode)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: auth.isLoading
                                        ? null
                                        : () => _forgotPassword(auth),
                                    child: const Text('Forgot Password?'),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: auth.isLoading
                                      ? null
                                      : () => _submit(auth),
                                  child: auth.isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                          ),
                                        )
                                      : Text(
                                          _isLoginMode
                                              ? 'Sign In'
                                              : 'Register',
                                        ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: auth.isLoading
                                    ? null
                                    : () {
                                        auth.clearError();
                                        _formKey.currentState?.reset();
                                        _confirmPasswordController.clear();
                                        setState(() {
                                          _isLoginMode = !_isLoginMode;
                                        });
                                      },
                                child: Text(
                                  _isLoginMode
                                      ? "Don't have an account? Register"
                                      : 'Already have an account? Sign In',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
