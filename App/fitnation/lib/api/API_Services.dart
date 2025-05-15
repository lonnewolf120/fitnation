import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fitnation/models/User.dart'; 

const String baseUrl = "http://localhost:8000/api/v1"; // Replace with your actual backend URL

class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ApiService(this._dio, this._secureStorage) {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add JWT token to headers if available
        final token = await _secureStorage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options); // continue
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Handle token expiration/invalidation, e.g., logout user or refresh token
          print("ApiService: Unauthorized error - Token might be expired.");
          // You might want to call a logout method from your auth provider here
          // or attempt a token refresh if you implement that.
          await _secureStorage.delete(key: 'access_token');
          await _secureStorage.delete(key: 'refresh_token');
        }
        return handler.next(e); // continue
      },
    ));
  }

  // --- Auth Endpoints ---
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'username': username,
        'email': email,
        'password': password,
      });
      return response.data; // Expects User object
    } on DioException catch (e) {
      throw _handleDioError(e, "Registration failed");
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      // FastAPI's OAuth2PasswordRequestForm expects form data
      final formData = FormData.fromMap({
        'username': username,
        'password': password,
      });
      final response = await _dio.post('/auth/login', data: formData);
      return response.data; // Expects Token object {access_token, refresh_token, token_type}
    } on DioException catch (e) {
      throw _handleDioError(e, "Login failed");
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      // The FastAPI /refresh-token endpoint expects the refresh token in the body.
      // Adjust if your backend expects it differently (e.g., as a header).
      final response = await _dio.post('/auth/refresh-token', data: refreshToken); // Simplified for example
      return response.data; // Expects new Token object
    } on DioException catch (e) {
      throw _handleDioError(e, "Token refresh failed");
    }
  }


  // --- User Endpoints ---
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e, "Failed to fetch current user");
    }
  }

  Future<UserModel> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      // Assuming your backend expects /users/{user_id} for profile updates
      // If it's /profiles/{user_id}, adjust the endpoint.
      final response = await _dio.put('/users/$userId', data: data);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e, "Failed to update profile");
    }
  }

  // --- Profile Endpoints (Example, assuming /profiles/{user_id}) ---
  // Future<ProfileModel> getProfile(String userId) async { ... }
  // Future<ProfileModel> updateProfile(String userId, Map<String, dynamic> data) async { ... }


  // --- Post Endpoints (Example) ---
  // Future<List<PostModel>> getPosts() async { ... }
  // Future<PostModel> createPost(Map<String, dynamic> data) async { ... }

  String _handleDioError(DioException e, String defaultMessage) {
    if (e.response != null && e.response!.data != null && e.response!.data['detail'] != null) {
      if (e.response!.data['detail'] is List) {
        // Handle FastAPI validation errors which are often lists of error objects
        return (e.response!.data['detail'] as List).map((err) => err['msg'] ?? 'Validation error').join(', ');
      }
      return e.response!.data['detail'].toString();
    }
    return e.message ?? defaultMessage;
  }
}

// Provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(Dio(), const FlutterSecureStorage());
});