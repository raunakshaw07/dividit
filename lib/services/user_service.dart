import 'dart:typed_data';
import 'package:dividit/types/app_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class UserService {
  final _supabaseClient = Supabase.instance.client;
  final users = Supabase.instance.client.from(
    dotenv.env['USERS_DB_NAME'] as String,
  );
  String? get currentUserId => _supabaseClient.auth.currentSession?.user.id;
  String? get currentUserEmail =>
      _supabaseClient.auth.currentSession?.user.email;
  Map<String, dynamic>? get userMetadata =>
      _supabaseClient.auth.currentSession?.user.userMetadata;

  // -----------------------------------
  // 🔐 Create or Insert User in the 'users' table
  // -----------------------------------
  Future<AppResponse> createUser({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? dob,
    String? imageUrl,
  }) async {
    final userData = {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'dob': dob,
      'image_url': imageUrl,
    };

    try {
      final response = await users.insert(userData).select();
      return AppResponse.setSuccess("User created successfully!", response[0]);
    } catch (e) {
      return AppResponse.setError(e.toString());
    }
  }

  // -----------------------------------
  // 🔐 Get User Data
  // -----------------------------------
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final response =
          await users
              .select()
              .eq('id', userId)
              .maybeSingle(); // won't throw if 0 rows
      return response;
    } catch (e) {
      // throw "Error fetching user data: $e";
      return null;
    }
  }

  // -----------------------------------
  // 🔐 Update User Data
  // -----------------------------------
  Future<Map<String, dynamic>> updateUserData({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? dob,
    String? imageUrl,
  }) async {
    final updates = <String, dynamic>{};

    updates['email'] = email;
    updates['name'] = name;
    updates['phone'] = phone;
    updates['dob'] = dob;
    updates['image_url'] = imageUrl;
    updates['updated_at'] = DateTime.now().toIso8601String();

    try {
      final data = await users.update(updates).eq('id', id as Object).select();

      if (data.isEmpty) {
        return {
          'status': 'failed',
          'message': 'User not found or no data returned',
        };
      }

      return {
        'status': 'success',
        'user': data,
        'message': 'User updated successfully!',
      };
    } catch (e) {
      return {'status': 'failed', 'message': e.toString()};
    }
  }

  // -----------------------------------
  // 📤 Upload Profile Picture to Supabase Storage
  // -----------------------------------
  Future<String> uploadProfilePicture(
    Uint8List fileBytes,
    String filePath,
  ) async {
    try {
      await _supabaseClient.storage
          .from('dividit-profile-images')
          .uploadBinary(
            filePath,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      return _supabaseClient.storage
          .from('dividit-profile-images')
          .getPublicUrl(filePath);
    } catch (e) {
      throw 'Error uploading profile picture: $e';
    }
  }
}
