import 'package:dividit/controllers/auth_controller.dart';
import 'package:dividit/controllers/user_controller.dart';
import 'package:dividit/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController _userController = Get.find<UserController>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final currentUser = _userController.currentUser.value;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to DividIt",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              Obx(() {
                final isLoggedIn = _userController.currentUser.value != null;

                if (isLoggedIn) {
                  final imageUrl = _userController.currentUser.value?.imageUrl;

                  return Column(
                    children: [
                      if (imageUrl != null)
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(imageUrl),
                        )
                      else
                        const CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person, size: 50),
                        ),

                      const SizedBox(height: 20),
                      const Text(
                        "User Information:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      InfoItem(
                        label: "Name",
                        value: currentUser?.name != null ? currentUser?.name as String : '',
                      ),
                      InfoItem(
                        label: "Email",
                        value:currentUser?.email != null ? currentUser?.email as String : '',
                      ),
                      InfoItem(
                        label: "Phone",
                        value: currentUser?.phone != null ? currentUser?.phone as String : '',
                      ),
                      InfoItem(
                        label: "Date of Birth",
                        value: "${currentUser?.dob}",
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await _authController.signOut();
                        },
                        child: const Text("Sign Out"),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      const Text(
                        "User Not Logged In Yet!!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to login page
                          Get.toNamed(AppRoutes.login);
                        },
                        child: const Text("Sign In"),
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const InfoItem({Key? key, required this.label, required this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value.isNotEmpty ? value : "Not provided"),
        ],
      ),
    );
  }
}
