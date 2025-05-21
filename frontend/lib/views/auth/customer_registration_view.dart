import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Spotless/services/auth_service.dart';

class CleanerRegistrationView extends StatefulWidget {
  const CleanerRegistrationView({super.key});

  @override
  State<CleanerRegistrationView> createState() => _CleanerRegistrationViewState();
}

class _CleanerRegistrationViewState extends State<CleanerRegistrationView> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();

  bool _isLoading = false;

  void _registerCleaner() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final response = await _authService.registerCleaner(
      email: _emailController.text.trim(),
      username: _usernameController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
      nationalId: _nationalIdController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cleaner registered successfully")),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      final body = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: ${body['detail'] ?? body.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Cleaner")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              const Text("Cleaner Registration", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (val) => val == null || val.isEmpty ? "Enter your email" : null,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (val) => val == null || val.isEmpty ? "Enter your username" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                validator: (val) => val == null || val.isEmpty ? "Enter phone number" : null,
              ),
              TextFormField(
                controller: _nationalIdController,
                decoration: const InputDecoration(labelText: "National ID"),
                validator: (val) => val == null || val.isEmpty ? "Enter your national ID" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (val) => val == null || val.length < 6 ? "Minimum 6 characters" : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _isLoading ? null : _registerCleaner,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
