
import 'package:dividit/controllers/auth_controller.dart';
import 'package:dividit/routes/app_routes.dart';
import 'package:dividit/types/app_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailLoginForm extends StatefulWidget {
  final bool isLogin;
  const EmailLoginForm({super.key, required this.isLogin});

  @override
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  final _authController = AuthController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _showPasswordValidation = false;

  @override
  void initState() {
    super.initState();
    _confirmPasswordFocusNode.addListener(() {
      setState(() {
        _showPasswordValidation = true;
      });
    });
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("⚠️ Validation Error", "All fields are required.");
      return;
    }

    if (!isValidEmail(email)) {
      Get.snackbar("⚠️ Validation Error", "Enter a valid email address.");
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        "⚠️ Validation Error",
        "Password must be at least 6 characters.",
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("❌ Mismatch", "Passwords do not match.");
      return;
    }

    try {
      final AppResponse response = await _authController
          .signUpWithEmailPassword(email, password);

      final user = response.user;
      if (user == null) {
        Get.snackbar("❌ Error", response.error as String);
        return;
      }

      Get.snackbar("✅ Success", response.message as String);
      Get.toNamed(AppRoutes.userInfo);
    } catch (e) {
      Get.snackbar("❌ Error", "$e");
    }
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "⚠️ Validation Error",
        "Email and password cannot be empty.",
      );
      return;
    }

    try {
      await _authController.signInWithEmailPassword(email, password);
      Get.toNamed(AppRoutes.home);
    } catch (e) {
      if (mounted) {
        Get.snackbar("❌ Error", "$e");
      }
    }
  }

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
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
