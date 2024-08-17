// lib/views/profile_view.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_task_track/views/edit_profile_view.dart';
import 'package:mobile_task_track/widgets/navigation_bottom_buttons.dart';
import 'package:mobile_task_track/widgets/profile_widget.dart';
import 'package:mobile_task_track/services/api_service.dart';
import 'package:mobile_task_track/models/user_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _testController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  late ApiService _apiService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();

    // Carregar dados do usuário ao iniciar a tela
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      final response = await _apiService.fetchUserById(userId!);
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        print('Dados do usuário: $userData');

        setState(() {
          _idController.text = userData['_id'];
          _nickNameController.text = userData['nickname'] ?? '';
          _nameController.text = userData['username'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _passwordController.text = userData['password'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _testController.text = userData['test'] ?? '';
          _isLoading = false;
        });
      } else {
        // Tratar erro ou usuário não encontrado
        print('Erro ao carregar dados do usuário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar dados do usuário: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _testController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 63, 110),
        title: const Text('Perfil'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    const Center(
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(
                            'https://images.mantosdofutebol.com.br/wp-content/uploads/2021/01/Cruzeiro-atualiza-escudo-com-pequenas-modificacoes-1.jpg'),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        _nickNameController.text,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Detalhes do Perfil',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ProfileInfoField(
                      label: 'Nome',
                      value: _nameController.text,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 15),
                    ProfileInfoField(
                      label: 'Email',
                      value: _emailController.text,
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 15),
                    const ProfileInfoField(
                      label: 'Senha',
                      value: /*_passwordController.text*/ '********',
                      icon: Icons.lock,
                    ),
                    const SizedBox(height: 15),
                    ProfileInfoField(
                      label: 'Telefone',
                      value: _phoneController.text,
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 15),
                    ProfileInfoField(
                      label: 'Apelido',
                      value: _nickNameController.text,
                      icon: Icons.text_fields,
                    ),
                    const SizedBox(height: 45),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final updatedUserData =
                              await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                userData: {
                                  '_id': _idController.text,
                                  'username': _nameController.text,
                                  'email': _emailController.text,
                                  'nickname': _nickNameController.text,
                                  'phone': _phoneController.text,
                                  'password': _passwordController.text,
                                },
                              ),
                            ),
                          );
                          if (updatedUserData != null) {
                            setState(
                              () {
                                _idController.text =
                                    updatedUserData['_id'] ?? '';
                                _nickNameController.text =
                                    updatedUserData['nickname'] ?? '';
                                _nameController.text =
                                    updatedUserData['username'] ?? '';
                                _emailController.text =
                                    updatedUserData['email'] ?? '';
                                _phoneController.text =
                                    updatedUserData['phone'] ?? '';
                                _passwordController.text =
                                    updatedUserData['password'] ?? '';
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor:
                              const Color.fromARGB(255, 5, 63, 110),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Editar',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      persistentFooterButtons: const [NavigationBottomButtons()],
    );
  }
}
