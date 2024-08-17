// lib/views/login_view.dart

import 'package:flutter/material.dart';
import 'package:mobile_task_track/services/api_service.dart';
import 'package:mobile_task_track/models/user_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await _apiService.loginUser(email, password);

    if (response != null) {
      final userId = response['id'];
      print('ID Usuario $userId');
      // Atualizar o UserProvider com o ID do usuário
      Provider.of<UserProvider>(context, listen: false).setUserId(userId);
      // Navegar para a tela de perfil
      Navigator.pushReplacementNamed(context, '/profile', arguments: userId);
    } else {
      // Exibir mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Login falhou. Verifique suas credenciais.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 63, 110),
        title: const Text('Login Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'TASK TRACK MOBILE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 34, color: Color.fromRGBO(67, 54, 51, 100)),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Color.fromRGBO(67, 54, 51, 100),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color.fromRGBO(67, 54, 51, 100),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    backgroundColor: const Color.fromARGB(255, 5, 63, 110),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Login',
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
