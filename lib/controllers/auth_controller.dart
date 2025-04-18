import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';
import '../controllers/user_controller.dart';
import '../types/app_response.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final UserController _userController = Get.find<UserController>();

  var isLoggedIn = false.obs;
  var userId = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAndUpdateAuthState();

    _authService.onAuthStateChange.listen((authState) {
      updateAuthState(authState.session);

      if (authState.session != null) {
        _fetchUserData(authState.session!.user.id);
      }
    });
  }

  void checkAndUpdateAuthState() {
    final session = _authService.currentSession;
    updateAuthState(session);

    if (session != null) {
      _fetchUserData(session.user.id);
    }
  }

  void updateAuthState(Session? session) {
    if (session != null) {
      isLoggedIn.value = true;
      userId.value = session.user.id;
      userEmail.value = session.user.email ?? '';
      userPhone.value = session.user.phone ?? '';
    } else {
      isLoggedIn.value = false;
      userId.value = '';
      userEmail.value = '';
      userPhone.value = '';
    }
  }
  
  Future<void> _fetchUserData(String userId) async {
    try {
      final userData = await _userController.getSingleUserData(userId);
      if (userData.user != null) {
        _userController.setUserData(userData.user);
      } else {
        print('No user data found for user ID: $userId');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<AppResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _authService.signUpWithEmailPassword(
        email,
        password,
      );

      if (response.user != null) {
        Get.toNamed(AppRoutes.userInfo);
        return AppResponse.setSuccess(
          "User signed in successfully!",
          response.user?.userMetadata,
        );
      }

      return AppResponse.setError(
        "Error while signing up user. Please try again",
      );
    } catch (e) {
      return AppResponse.setError(e.toString());
    }
  }

  Future<AppResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _authService.signInWithEmailPassword(
        email,
        password,
      );
      if (response.user != null) {
        Get.offAllNamed(AppRoutes.home);
        return AppResponse.setSuccess(
          "user signed in successfully!",
          response.user?.userMetadata,
        );
      }

      return AppResponse.setError(
        "Error while signing in user. Please try again",
      );
    } catch (e) {
      return AppResponse.setError(e.toString());
    }
  }

  Future<AppResponse> signInWithGoogle(bool isLogin) async {
    try {
      final response = await _authService.signInWithGoogle();
      if (response != null && response.user != null) {
        if (isLogin) {
          Get.offAllNamed(AppRoutes.home);
        } else {
          Get.toNamed(AppRoutes.userInfo);
        }

        return AppResponse.setSuccess(
          "user signed in successfully!",
          response.user?.userMetadata,
        );
      }
      return AppResponse.setError(
        "Error while signing in user. Please try again",
      );
    } catch (e) {
      return AppResponse.setError(e.toString());
    }
  }

  Future<void> signInWithPhone(String phoneNumber) async {
    try {
      await _authService.signInWithPhone(phoneNumber);
    } catch (e) {
      print('Phone sign in error: $e');
      rethrow;
    }
  }

  Future<AppResponse> verifyPhoneOtp({
    required String phoneNumber,
    required String otp,
    required bool isLogin,
  }) async {
    try {
      final response = await _authService.verifyPhoneOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );
      if (response.user != null) {
        if (isLogin) {
          Get.toNamed(AppRoutes.home);
        } else {
          Get.toNamed(AppRoutes.userInfo);
        }
        return AppResponse.setSuccess(
          "user signed in successfully!",
          response.user?.userMetadata,
        );
      }

      return AppResponse.setError(
        "Error while signing in user. Please try again",
      );
    } catch (e) {
      return AppResponse.setError(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }
}
