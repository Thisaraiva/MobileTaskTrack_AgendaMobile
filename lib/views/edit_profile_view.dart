import 'package:flutter/material.dart';
import 'package:mobile_task_track/services/api_service.dart';
import 'package:mobile_task_track/views/profile_view.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ApiService apiService = ApiService();

  late TextEditingController idController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;
  late TextEditingController nicknameController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.userData['_id']);
    usernameController =
        TextEditingController(text: widget.userData['username']);
    emailController = TextEditingController(text: widget.userData['email']);
    passwordController = TextEditingController();
    phoneController = TextEditingController(text: widget.userData['phone']);
    nicknameController =
        TextEditingController(text: widget.userData['nickname']);
  }

  void updateUser() async {    
    String? password =
        passwordController.text.isNotEmpty ? passwordController.text : null;
    String? email =
        emailController.text.isNotEmpty ? emailController.text : null;
    String? username =
        usernameController.text.isNotEmpty ? usernameController.text : null;

    Map<String, dynamic> userData = {
      '_id': idController.text,
      'username': username,
      'email': email,
      'password': password,
      'nickname': nicknameController.text,
      'phone': phoneController.text,
    };

    // Remove campos nulos
    userData.removeWhere((key, value) => value == null);
    print('Dados do usuario editRealizado: $userData');

    try {
      final response =
          await apiService.updateUser(widget.userData['_id'], userData);

      if (response.statusCode == 200) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(
          builder: (context) => const ProfilePage())); // Volta para a tela de perfil com os novos dados
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: ${response.body}')),
        );
        print('Update failed: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print('Dados do usuario edit: $userData');
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nicknameController.dispose();
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 63, 110),
        title: const Text('Edit Profile'),
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
                  style: TextStyle(
                      fontSize: 34, color: Color.fromRGBO(67, 54, 51, 100)),
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
                    labelText: 'Senha (deixe em branco para não alterar)',
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
                  onPressed: updateUser,
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    backgroundColor: const Color.fromARGB(255, 5, 63, 110),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Save',
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
