import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fitnation/api/API_Services.dart';
import 'package:fitnation/models/User.dart'; // Create this model

// --- Auth State ---
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  final String? message; // Optional error message
  Unauthenticated({this.message});
}

// --- Auth Notifier ---
class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage;

  AuthNotifier(this._apiService, this._secureStorage) : super(AuthInitial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = AuthLoading();
    try {
      final accessToken = await _secureStorage.read(key: 'access_token');
      if (accessToken != null && accessToken.isNotEmpty) {
        // Optionally validate token by fetching user data
        final user = await _apiService.getCurrentUser();
        state = Authenticated(user);
      } else {
        state = Unauthenticated();
      }
    } catch (e) {
      print("Auth check failed: $e");
      await _secureStorage.delete(
        key: 'access_token',
      ); // Clear potentially invalid token
      await _secureStorage.delete(key: 'refresh_token');
      state = Unauthenticated(message: "Session expired. Please login again.");
    }
  }

  Future<void> login(String username, String password) async {
    state = AuthLoading();
    try {
      final tokenData = await _apiService.login(username, password);
      await _secureStorage.write(
        key: 'access_token',
        value: tokenData['access_token'],
      );
      if (tokenData['refresh_token'] != null) {
        await _secureStorage.write(
          key: 'refresh_token',
          value: tokenData['refresh_token'],
        );
      }

      // Fetch user data after successful login
      final user = await _apiService.getCurrentUser();
      state = Authenticated(user);
    } catch (e) {
      state = Unauthenticated(message: e.toString());
    }
  }

  Future<void> register(String username, String email, String password) async {
    state = AuthLoading();
    try {
      // API's register endpoint might return the created user directly or just a success message.
      // If it returns the user, you can proceed to login or fetch user data.
      // For simplicity, let's assume it doesn't auto-login.
      await _apiService.register(username, email, password);
      // After successful registration, you might want to auto-login or prompt user to login.
      // For this example, we'll just transition to Unauthenticated for them to login.
      state = Unauthenticated(
        message: "Registration successful! Please login.",
      );
    } catch (e) {
      state = Unauthenticated(message: e.toString());
    }
  }

  Future<void> logout() async {
    state = AuthLoading();
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
    // You might want to call a backend logout endpoint if it exists
    // to invalidate server-side sessions or refresh tokens.
    state = Unauthenticated();
  }

  // Optional: Attempt to refresh token
  Future<bool> attemptTokenRefresh() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) return false;

    try {
      final tokenData = await _apiService.refreshToken(refreshToken);
      await _secureStorage.write(
        key: 'access_token',
        value: tokenData['access_token'],
      );
      if (tokenData['refresh_token'] != null) {
        // Handle token rotation
        await _secureStorage.write(
          key: 'refresh_token',
          value: tokenData['refresh_token'],
        );
      }
      // Optionally re-fetch user data to confirm
      final user = await _apiService.getCurrentUser();
      state = Authenticated(user);
      return true;
    } catch (e) {
      print("Token refresh failed: $e");
      await logout(); // Force logout if refresh fails
      return false;
    }
  }
}

// --- Auth Provider ---
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthNotifier(apiService, const FlutterSecureStorage());
});

// Provider to easily access the current user if authenticated
final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState is Authenticated) {
    return authState.user;
  }
  return null;
});
