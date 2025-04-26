import 'package:dividit/components/home/info_card.dart';
import 'package:dividit/controllers/user_controller.dart';
import 'package:dividit/routes/app_routes.dart';
import 'package:dividit/types/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController _userController = Get.find<UserController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _userController.currentUser.value;
    // User? currentUser = User(
    //   name: 'Test user',
    //   email: 'test@gmail.com',
    //   phone: '123132131',
    //   dob: DateTime.now(),
    // );

    // Todo: Create a shared settle up function to be used in multiple components
    onSettleUpButtonPress() {
      print("Clicked");
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              final imageUrl = currentUser?.imageUrl;
              return GestureDetector(
                onTap: () {
                  // Handle tap on profile
                },
                child: CircleAvatar(
                  backgroundColor: Colors.purple[200],
                  backgroundImage:
                      imageUrl != null ? NetworkImage(imageUrl) : null,
                  child:
                      imageUrl == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                ),
              );
            }),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text(
                'DividIt Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Add more drawer items here
          ],
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final isLoggedIn = _userController.currentUser.value != null; 

          if (isLoggedIn) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity, // 👈 This makes the Card expand full width
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 225, 225, 225),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center, // Optional: align text left
                          children: [
                            Text(
                              "My Balance",
                            ),
                            SizedBox(height: 10),
                            Text(
                              "\$1,234.56",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: onSettleUpButtonPress,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200], // 👈 Grey color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30), // 👈 Semi-circular (pill shaped)
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12), // Optional: bigger button
                              ),
                              child: const Text(
                                "Settle Up",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      InfoCard(
                        title: "Group",
                        icon: Icons.groups,
                        color: const Color.fromARGB(90, 255, 214, 79),
                        iconColor: const Color.fromARGB(255, 251, 197, 17),
                        onTap: () => { print("group") },
                      ),
                      const SizedBox(width: 20), // <-- Proper spacing between cards
                      InfoCard(
                        title: "Individual",
                        icon: Icons.person,
                        color: const Color.fromARGB(90, 103, 185, 107),
                        iconColor: const Color.fromARGB(255, 103, 185, 107),
                        onTap: () => { print("Individual") },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20,),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Activities",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "No recent activities",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),



                  // CircleAvatar(
                  //   radius: 50,
                  //   backgroundColor: Colors.purple[200],
                  //   backgroundImage:
                  //       imageUrl != null ? NetworkImage(imageUrl) : null,
                  //   child:
                  //       imageUrl == null
                  //           ? const Icon(
                  //             Icons.person,
                  //             size: 50,
                  //             color: Colors.white,
                  //           )
                  //           : null,
                  // ),

                  // const SizedBox(height: 20),
                  // const Text(
                  //   "User Information:",
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(height: 10),

                  // _buildInfoRow("Name", currentUser?.name ?? "Not provided"),
                  // _buildInfoRow("Email", currentUser?.email ?? "Not provided"),
                  // _buildInfoRow("Phone", currentUser?.phone ?? "Not provided"),
                  // _buildInfoRow(
                  //   "Date of Birth",
                  //   currentUser?.dob.toString() ?? "Not provided",
                  // ),

                  const SizedBox(height: 20),
                  
                  // todo: shift this to a safer component
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.red,
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 30,
                  //       vertical: 12,
                  //     ),
                  //   ),
                  //   onPressed: () async {
                  //     await _authController.signOut();
                  //   },
                  //   child: const Text(
                  //     "Sign Out",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome to DividIt",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "User Not Logged In Yet!!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.login);
                      },
                      child: const Text("Sign In"),
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
