import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

import '../../model/user.dart';

class UserService {
  // Resolve a sensible default baseUrl depending on the platform/emulator.
  static String _resolveBaseUrl() {
    // Web runs in the browser so `localhost` refers to the dev machine
    if (kIsWeb) return 'http://localhost:3000';

    // For Android emulators (AVD), host machine is reachable via 10.0.2.2
    // For Genymotion use 10.0.3.2 (not handled automatically here)
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3000';
      } else if (Platform.isIOS) {
        // iOS simulator maps localhost to host machine
        return 'http://localhost:3000';
      } else {
        // Desktop (Windows/macOS/Linux) & others
        return 'http://localhost:3000';
      }
    } catch (e) {
      // Fallback
      return 'http://localhost:3000';
    }
  }

  // Default shared Dio configured with the resolved base URL.
  static final Dio defaultDio = Dio(BaseOptions(baseUrl: _resolveBaseUrl()));

  // Instance Dio - allows overriding (useful for tests or custom configs).
  final Dio _dio;

  UserService({Dio? dio}) : _dio = dio ?? UserService.defaultDio;

  /// Current base URL used by this service (useful for debugging connections).
  String get baseUrl => _dio.options.baseUrl;

  Future<User> getUsers({required int page, required int limit}) async {
    try {
      final response = await _dio.get(
        '/users',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        // Debug: print a quick summary of returned image field for the first user
        try {
          final data = response.data;
          if (data is Map &&
              data['users'] is List &&
              (data['users'] as List).isNotEmpty) {
            final first = (data['users'] as List)[0];
            if (first is Map && first.containsKey('imageBase64')) {
              final img = first['imageBase64'];
              String preview;
              if (img == null)
                preview = 'null';
              else if (img is String)
                preview =
                    'String(len=${img.length}) ${img.length > 100 ? img.substring(0, 100) : img}';
              else if (img is List)
                preview = 'List(len=${img.length})';
              else
                preview = img.runtimeType.toString();

              print('DEBUG getUsers: first.imageBase64 -> $preview');
            }
          }
        } catch (_) {
          // ignore debug failures
        }
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  Future<UserElement> getUserById({required int id}) async {
    try {
      final response = await _dio.get('/users/$id');

      if (response.statusCode == 200) {
        return UserElement.fromJson(response.data);
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  Future<dynamic> createUser({required String name, XFile? imageFile}) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        if (imageFile != null)
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.name,
          ),
      });

      final response = await _dio.post('/users', data: formData);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }
}
