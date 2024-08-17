import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_task_track/widgets/navigation_bottom_buttons.dart';
import 'package:mobile_task_track/services/api_service.dart';
import 'package:mobile_task_track/models/user_provider.dart';

class TaskCreate extends StatefulWidget {
  const TaskCreate({super.key});

  @override
  State<TaskCreate> createState() => _TaskCreateState();
}

class _TaskCreateState extends State<TaskCreate> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _status = 'A fazer';
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createTask(BuildContext context) async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) {
      print('Dados do usuário null Tasks: $userId');
      // Trate o caso de erro, usuário não logado
      return;
    }
    final newTask = {
      'userId': userId,
      'title': _taskController.text,
      'description': _descriptionController.text,
      'date': _dateController.text,
      'status': _status,
    };
    final response = await _apiService.createTask(newTask);
    if (response.statusCode == 201) {
      print('Tarefa criada com sucesso: $newTask');
      print('Dados do usuário Tasks: $newTask');
      Navigator.pushReplacementNamed(context, '/taskList');
    } else {
      print('Erro ao criar tarefa: ${response.statusCode} - ${response.body}');
      print('Dados do usuário erro Tasks: $userId e nova tarefa $newTask');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 63, 110),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Nova Tarefa',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _taskController,
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  labelText: 'Tarefa',
                  hintText: 'Digite o nome da tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _dateController,
                readOnly: false,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  labelText: 'Data',
                  hintText: 'DD/MM/AAAA',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _status,
                items: <String>['A fazer', 'Em processo', 'Realizada']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                textAlign: TextAlign.left,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Descreva a tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _createTask(context),
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    backgroundColor: const Color.fromARGB(255, 5, 63, 110),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Salvar',
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
