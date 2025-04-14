import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

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
  // 🔐 Email/Password Auth
  // -----------------------------------
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return _supabaseClient.auth.signUp(email: email, password: password);
  }

  // -----------------------------------
  // 🔐 Google Auth
  // -----------------------------------
  Future<void> signInWithGoogle() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await _mobileGoogleSignIn();
    } else {
      await _webGoogleSignIn();
    }
  }

  Future<void> _mobileGoogleSignIn() async {
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

    await _supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<void> _webGoogleSignIn() async {
    await _supabaseClient.auth.signInWithOAuth(OAuthProvider.google);
  }

  // -----------------------------------
  // 📱 Phone Auth (OTP-based)
  // -----------------------------------

  /// Step 1: Request OTP to be sent to phone number
  /// Example: "+911234567890"
  Future<void> signInWithPhone(String phoneNumber) async {
    try {
      await _supabaseClient.auth.signInWithOtp(phone: phoneNumber);
      // print("OTP sent successfully to $phoneNumber");
    } catch (e) {
      // print("Failed to send OTP: $e");
      rethrow;
    }
  }

  /// Step 2: Verify the OTP
  /// [phoneNumber] must match the one used in `signInWithPhone`
  /// [otp] is the code received via SMS
  Future<void> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      // print("$phoneNumber - $otp");
      await _supabaseClient.auth.verifyOTP(
        type: OtpType.sms,
        phone: "+91$phoneNumber",
        token: otp,
      );
    } catch (e) {
      // print("OTP verification failed: $e");
      rethrow;
    }
  }

  // -----------------------------------
  // ✨ Utilities
  // -----------------------------------
  String? currentUserEmail() {
    return currentSession?.user.email;
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }
}
