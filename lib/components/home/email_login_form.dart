import 'package:dividit/auth/auth_service.dart';
import 'package:flutter/material.dart';

class EmailLoginForm extends StatefulWidget {
  final bool isLogin;
  const EmailLoginForm({Key? key, required this.isLogin}) : super(key: key);

  @override
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _showPasswordValidation = false;

  @override
  void initState() {
    super.initState();

    // Listen for blur event on confirm password field
    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus) {
        setState(() {
          _showPasswordValidation = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  /// Basic email format validation
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Sign-up handler with all validations
  void _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar("⚠️ All fields are required.");
      return;
    }

    if (!isValidEmail(email)) {
      _showSnackbar("⚠️ Enter a valid email address.");
      return;
    }

    if (password.length < 6) {
      _showSnackbar("⚠️ Password must be at least 6 characters.");
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar("❌ Passwords do not match.");
      return;
    }

    try {
      await _authService.signInWithEmailPassword(email, password);
      // Optional: show success message or navigate
    } catch (e) {
      if (mounted) {
        _showSnackbar("❌ Error: $e");
      }
    }
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // print("$email - $password");

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("⚠️ Email and password cannot be empty.");
      return;
    }

    try {
      await _authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        _showSnackbar("❌ Error: $e");
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Password match validation UI
  Widget buildPasswordValidationMessage() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (!_showPasswordValidation ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return const SizedBox.shrink();
    } else if (password != confirmPassword) {
      return const Text(
        "❌ Passwords do not match.",
        style: TextStyle(color: Colors.red),
      );
    } else {
      return const Text(
        "✅ Passwords match!",
        style: TextStyle(color: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              if (!widget.isLogin)
                TextField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),

              const SizedBox(height: 10),
              if (!widget.isLogin) buildPasswordValidationMessage(),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.isLogin ? _handleLogin : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    widget.isLogin
                        ? "Sign In with Email"
                        : "Sign Up with Email",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
