import 'package:dividit/auth/auth_service.dart';
import 'package:dividit/components/home/email_login_form.dart';
import 'package:dividit/components/home/phone_otp_login_form.dart';
import 'package:dividit/pages/sign_up.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Welcome to DividIt",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TabBar(
                    labelColor: Colors.deepPurple,
                    unselectedLabelColor: Colors.black54,
                    indicatorColor: Colors.deepPurple,
                    tabs: [
                      Tab(text: "Email Login"),
                      Tab(text: "Phone OTP"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 280,
                  child: const TabBarView(
                    children: [
                      EmailLoginForm(isLogin: true),
                      PhoneOtpLoginForm(isLogin: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "or",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text(
                    "Sign In with Google",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _authService.signInWithGoogle(),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp())),
                  child: const Center(child: Text("Don't have an account? Sign Up Here")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
