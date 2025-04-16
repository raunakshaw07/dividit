import 'dart:typed_data';

import 'package:dividit/routes/app_routes.dart';
import 'package:dividit/services/user_service.dart';
import 'package:dividit/types/AppResponse.dart';
import 'package:dividit/types/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();
  final Rxn<User> currentUser = Rxn<User>();

  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString imageUrl = ''.obs;
  Rx<DateTime> dob = DateTime.now().obs;

  void setUserData(Map<String, dynamic> user) {
    User newUser = User.fromMap(user);
    currentUser.value = newUser;
    
    name.value = newUser.name ?? '';
    email.value = newUser.email ?? '';
    phone.value = newUser.phone ?? '';
    imageUrl.value = newUser.imageUrl ?? '';
    
    if (newUser.dob != null) {
      dob.value = newUser.dob as DateTime;
    } else {
      dob.value = DateTime.now();
    }
    
    update();
  }

  Future<AppResponse> getSingleUserData(String id) async {
    try {
      final response = await _userService.getUserData(id);
      if (response != null) {
        return AppResponse.setSuccess("User fetched successfully", response);
      }
      return AppResponse.setError("Error while fetching user data");
    } catch (e) {
      return AppResponse.setError(e.toString());
    }
  }

  Future<AppResponse> createUser({
    required String? id,
    String? name,
    String? email,
    String? phone,
    String? dob,
    String? imageUrl,
  }) async {
    try {
      final result = await _userService.createUser(
        id: id,
        name: name ?? '',
        email: email ?? '',
        phone: phone ?? '',
        dob: dob ?? '',
        imageUrl: imageUrl,
      );

      if (result.success == 1 && result.user != null) {
        final insertedUser = result.user as Map<String, dynamic>;
        setUserData(insertedUser);
        return AppResponse.setSuccess(result.message as String, insertedUser);
      } else {
        return AppResponse.setError(result.message ?? 'Failed to create user');
      }
    } catch (e) {
      return AppResponse.setError(e.toString());
    }
  }

  Future<AppResponse> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? imageUrl,
    DateTime? dob,
  }) async {
    try {
      final user = currentUser.value;
      if (user == null) {
        return AppResponse.setError(
          "Authentication error: No user is currently logged in",
        );
      }

      final result = await _userService.updateUserData(
        id: user.id,
        name: name ?? '',
        email: email ?? '',
        phone: phone ?? '',
        dob: dob.toString(),
        imageUrl: imageUrl,
      );

      if (result['status'] == 'success') {
        final updatedUserFromDb =
            (result['user'] as List).first as Map<String, dynamic>;
        setUserData(updatedUserFromDb);

        Get.toNamed(AppRoutes.home);
        return AppResponse.setSuccess(
          'Profile updated successfully',
          updatedUserFromDb,
        );
      } else {
        return AppResponse.setError(
          "Failed to update profile: ${result['message']}",
        );
      }
    } catch (e) {
      return AppResponse.setError(e.toString());
    }
  }

  Future<void> updateProfilePicFromBytes(
    Uint8List fileBytes,
    String filename,
  ) async {
    try {
      final userId = _userService.currentUserId;
      if (userId == null) throw "User not logged in";

      final filePath = 'public/$userId/$filename';
      final publicUrl = await _userService.uploadProfilePicture(
        fileBytes,
        filePath,
      );

      imageUrl.value = publicUrl;
      updateProfile(imageUrl: publicUrl);
    } catch (e) {
      rethrow;
    }
  }
}
