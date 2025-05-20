import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://192.168.1.254:8000/auth/'; // update if deployed

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

  Future<http.Response> verifyEmail(String email) async {
    final url = Uri.parse('${baseUrl}verify-email/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response;
  }

  Future<http.Response> forgotPassword(String email) async {
    final url = Uri.parse('${baseUrl}password-reset/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response;
  }

  Future<http.Response> resetPassword({
    required String uid,
    required String token,
    required String newPassword,
  }) async {
    final url = Uri.parse('${baseUrl}password-reset-confirm/');
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
