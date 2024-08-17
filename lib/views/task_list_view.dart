import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_task_track/services/api_service.dart';
import 'package:mobile_task_track/models/user_provider.dart';
import 'package:mobile_task_track/widgets/navigation_bottom_buttons.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late ApiService _apiService;
  List<dynamic> _tasks = [];
  String _selectedStatus = 'Todos';
  
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) return;

    try {
      final response = await _apiService.fetchTasksByUserId(userId);
      print('Response from fetchTasksByStatus: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print the full response body
      if (response.statusCode == 200) {
        setState(() {
          _tasks = List.from(json.decode(response.body));
        });
      } else {
        print('Error fetching tasks: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in fetchTasks: $e');
    }
  }

  Future<void> _fetchTasksByStatus() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) return;

    try {
      final response =
          await _apiService.fetchTasksByStatus(userId, _selectedStatus);
      if (response.statusCode == 200) {
        setState(() {
          _tasks = List.from(json.decode(response.body));
        });
      } else {
        print('Error fetching tasks by status: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in fetchTasksByStatus: $e');
    }
  }

  Future<void> _fetchTasksByDateRange() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null || _selectedDateRange == null) return;

    print('Fetching tasks for user $userId between ${_selectedDateRange!.start} and ${_selectedDateRange!.end}');

    try {
        final response = await _apiService.fetchTasksByDateRange(userId, _selectedDateRange!);
        print('Response status code: ${response.statusCode}');
        if (response.statusCode == 200) {
            final tasks = json.decode(response.body);
            print('Fetched tasks: $tasks');
            setState(() {
                _tasks = List.from(tasks);
            });
        } else {
            print('Error fetching tasks by date range: ${response.statusCode}');
        }
    } catch (e) {
        print('Exception in fetchTasksByDateRange: $e');
    }
}

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      _fetchTasksByDateRange();
    }
  }

  Future<void> _searchTasks() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) return;

    if (_selectedStatus != 'Todos') {
      await _fetchTasksByStatus();
    } else if (_selectedDateRange != null) {
      await _fetchTasksByDateRange();
    } else {
      await _fetchTasks(); // Buscar todas as tarefas se nenhum filtro estiver selecionado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 63, 110),
        title: const Text('Lista de Tarefas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tarefas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => _selectDateRange(context),
                  icon: const Icon(
                    Icons.calendar_today,
                    color: Color.fromARGB(255, 5, 63, 110),
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _selectedStatus,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                      _searchTasks(); // Atualiza tarefas ao mudar o status
                    });
                  },
                  items: <String>[
                    'Todos',
                    'A fazer',
                    'Em processo',
                    'Realizada'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () => _searchTasks(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 5, 63, 110),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Pesquisar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(255, 255, 255, 0.612),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return ListTile(
                    title: Text(task['title']),
                    subtitle: Text(task['description']),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Color.fromARGB(255, 5, 63, 110),
                        size: 30,
                      ),
                      onPressed: () {
                        // Add logic to update task status
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: const [NavigationBottomButtons()],
    );
  }
}
