import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_task_track/services/api_service.dart';
import 'package:mobile_task_track/models/user_provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ApiService apiService = ApiService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  void registerUser() async {
    Map<String, dynamic> userData = {
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'nickname': nicknameController.text.isEmpty ? usernameController.text.split(' ')[0] : nicknameController.text,
      'phone': phoneController.text.isEmpty ? null : phoneController.text,
    };

    final response = await apiService.createUser(userData);

    if (response.statusCode == 201) {
      // Extract the userId from the response body
      final responseData = jsonDecode(response.body);
      final userId = responseData['_id'];

      // Save the userId to UserProvider
      Provider.of<UserProvider>(context, listen: false).setUserId(userId);

      // Navigate to ProfilePage
      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      // Handle registration error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${response.body}')
        ),
      );
      print('Registration failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 63, 110),
        title: const Text('Register Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'TASK TRACK MOBILE',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 34, color: Color.fromRGBO(67, 54, 51, 100)),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.account_box),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: nicknameController,
                  decoration: InputDecoration(
                    labelText: 'Apelido',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.text_snippet),
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    backgroundColor: const Color.fromARGB(255, 5, 63, 110),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(255, 255, 255, 0.612),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
