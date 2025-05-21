import 'package:flutter/material.dart';
import 'package:Spotless/services/auth_service.dart';

class ResetPasswordView extends StatefulWidget {
  final String uid;
  final String token;

  const ResetPasswordView({
    super.key,
    required this.uid,
    required this.token,
  });

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _authService = AuthService();

  void _submitReset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final response = await _authService.resetPassword(
      uid: widget.uid,
      token: widget.token,
      newPassword: _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password successfully reset.")),
      );
      Navigator.popUntil(context, (route) => route.isFirst); // Go back to login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error resetting password: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Enter a new password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "New Password"),
                validator: (val) => val == null || val.length < 6
                    ? "Password must be at least 6 characters"
                    : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitReset,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Reset Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
