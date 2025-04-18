import 'dart:io';
import 'package:dividit/controllers/user_controller.dart';
import 'package:dividit/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final userController = Get.find<UserController>();

  // Get current Supabase user session
  Session? get currentSession => _supabaseClient.auth.currentSession;

  // Get current user ID
  String? get currentUserId => currentSession?.user.id;

  // Get user metadata
  Map<String, dynamic>? get userMetadata => currentSession?.user.userMetadata;

  // Listen to auth state changes
  Stream<AuthState> get onAuthStateChange =>
      _supabaseClient.auth.onAuthStateChange;

  // -----------------------------------
  // 🔒 Email/Password Auth
  // -----------------------------------
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    final response = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) return response;

    userController.createUser(id: user.id, email: user.email);

    return response;
  }

  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw 'Login failed';

    final result = await userController.getSingleUserData(user.id);
    userController.setUserData(result.toMap());

    return response;
  }

  // -----------------------------------
  // 🔒 Google Auth
  // -----------------------------------
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      AuthResponse? response;

      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        response = await _mobileGoogleSignIn();
      } else {
        response = await _webGoogleSignIn();
        return null; // On web, Supabase handles redirection, nothing more to do.
      }

      final user = response.user;
      if (user == null) {
        throw 'No user returned from Google sign-in';
      }

      // Create user in DB via controller
      await userController.createUser(
        id: user.id,
        email: user.email,
        name: user.userMetadata?['name'] ?? '', // Or display_name if available
        imageUrl: user.userMetadata?['picture'], // Google returns picture URL
      );

      return response;
    } catch (e) {
      print("Google Sign-In Error: $e");
      rethrow;
    }
  }

  Future<AuthResponse> _mobileGoogleSignIn() async {
    final webClientId = dotenv.env['WEB_CLIENT_ID'];
    final iosClientId = dotenv.env['IOS_CLIENT_ID'];

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    final accessToken = googleAuth?.accessToken;
    final idToken = googleAuth?.idToken;

    if (accessToken == null || idToken == null) {
      throw 'Missing Google Auth tokens.';
    }

    return await _supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<AuthResponse?> _webGoogleSignIn() async {
    await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: AppRoutes.home,
    );
    return null;
  }

  // -----------------------------------
  // 📱 Phone Auth (OTP-based)
  // -----------------------------------
  Future<void> signInWithPhone(String phoneNumber) async {
    try {
      await _supabaseClient.auth.signInWithOtp(phone: phoneNumber);
      print("OTP sent successfully to $phoneNumber");
    } catch (e) {
      print("Failed to send OTP: $e");
      rethrow;
    }
  }

  Future<AuthResponse> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final response = await _supabaseClient.auth.verifyOTP(
      type: OtpType.sms,
      phone: "+91$phoneNumber",
      token: otp,
    );

    final user = response.user;

    if (user != null) {
      await userController.createUser(
        id: user.id,
        email: user.email,
        phone: user.phone,
      );
    }

    return response;
  }

  // -----------------------------------
  // ✨ Utilities
  // -----------------------------------
  String? currentUserEmail() {
    return currentSession?.user.email;
  }

  Future<void> signOut() async {
    userController.currentUser.value = null;
    await _supabaseClient.auth.signOut();
  }
}
