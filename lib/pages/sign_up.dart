import 'package:dividit/controllers/auth_controller.dart';
import 'package:dividit/components/auth/email_login_form.dart';
import 'package:dividit/components/auth/phone_otp_login_form.dart';
import 'package:dividit/pages/login.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _authController = AuthController();

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
                  "Welcome to Dividit!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sign Up Here",
                  style: TextStyle(
                    fontSize: 32,
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
                  height: 360,
                  child: const TabBarView(
                    children: [
                      EmailLoginForm(isLogin: false),
                      PhoneOtpLoginForm(isLogin: false),
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
                    "Sign Up with Google",
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
                  onPressed: () => _authController.signInWithGoogle(false),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Login())),
                  child: const Center(child: Text("Already have an account? Log In Here")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: Column(
  //         children: [
  //           EmailLoginForm(isLogin: false), 
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
