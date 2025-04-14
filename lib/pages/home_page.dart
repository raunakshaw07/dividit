import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  String? _userID;
  Map<String, dynamic>? _userMetadata;

  @override
  void initState() {
    super.initState();

    _userID = _authService.currentUserId;
    _userMetadata = _authService.userMetadata;

    _authService.onAuthStateChange.listen((data) {
      setState(() {
        _userID = data.session?.user.id;
        _userMetadata = data.session?.user.userMetadata;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = _userID != null;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome to DividIt", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              if (isLoggedIn && _userMetadata?['picture'] != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_userMetadata!['picture']),
                ),
              if (isLoggedIn) ...[
                const SizedBox(height: 20),
                Text("Hello, ${_userMetadata?['name'] ?? _authService.currentUserEmail()}"),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _authService.signOut(),
                  child: const Text("Sign Out"),
                ),
              ] else ...[
                Text("User Not Logged In Yet!!")
              ],
            ],
          ),
        ),
      ),
    );
  }
}
