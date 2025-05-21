import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final String baseUrl = 'https://0b05-196-216-85-41.ngrok-free.app/auth/'; // Update as needed

  // Google Sign-In setup
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Handles Google OAuth login
  Future<String?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      // Send the idToken to your Django backend
      final response = await http.post(
        Uri.parse('${baseUrl}google/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Use 'key' for dj-rest-auth, or 'access' for JWT
        final token = data['key'] ?? data['access'];
        return token;
      } else {
        print('Google login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Google sign-in error: $e');
      return null;
    }
  }

  /// Register a customer
  Future<http.Response> registerCustomer({
    required String email,
    required String username,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('${baseUrl}register/customer/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'phone_number': phone,
        'password': password,
      }),
    );
    return response;
  }

  /// Register a cleaner
  Future<http.Response> registerCleaner({
    required String email,
    required String username,
    required String phone,
    required String password,
    required String nationalId,
  }) async {
    final url = Uri.parse('${baseUrl}register/cleaner/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'phone_number': phone,
        'password': password,
        'national_id': nationalId,
      }),
    );
    return response;
  }

  /// Login with email and password
  Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${baseUrl}login/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    return response;
  }

  /// Send email verification
  Future<http.Response> verifyEmail(String email) async {
    final url = Uri.parse('${baseUrl}verify-email/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response;
  }

  /// Send forgot password email
  Future<http.Response> forgotPassword(String email) async {
    final url = Uri.parse('${baseUrl}password/reset/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response;
  }

  /// Confirm password reset
  Future<http.Response> resetPassword({
    required String uid,
    required String token,
    required String newPassword,
  }) async {
    final url = Uri.parse('${baseUrl}password/reset/confirm/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'uid': uid,
        'token': token,
        'new_password': newPassword,
      }),
    );
    return response;
  }
}