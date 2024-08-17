import 'package:flutter/material.dart';
import 'package:mobile_task_track/controllers/settings_controller.dart';
import 'package:mobile_task_track/views/home_page.dart';
import 'package:mobile_task_track/views/login_view.dart';
import 'package:mobile_task_track/views/profile_view.dart';
import 'package:mobile_task_track/views/register_view.dart';
import 'package:mobile_task_track/views/settings_view.dart';
import 'package:mobile_task_track/views/task_list_view.dart';
import 'package:mobile_task_track/views/tasks_create_view.dart';
import 'package:mobile_task_track/models/user_provider.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: AnimatedBuilder(
        animation: SettingsController.instance,
        builder: (context, child) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.lightBlue,
              brightness: SettingsController.instance.isDarkTheme
                  ? Brightness.dark
                  : Brightness.light,
            ),
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(builder: (_) => const HomePage());
                case '/login':
                  return MaterialPageRoute(builder: (_) => const LoginPage());
                case '/register':
                  return MaterialPageRoute(builder: (_) => const RegisterPage());
                case '/profile':
                  return MaterialPageRoute(builder: (_) => const ProfilePage());
                case '/taskCreate':
                  return MaterialPageRoute(builder: (_) => const TaskCreate());
                case '/taskList':
                  return MaterialPageRoute(builder: (_) => TaskList());
                case '/settings':
                  return MaterialPageRoute(builder: (_) => const SettingsView());
                default:
                  return _errorRoute(); // Handle unknown routes
              }
            },
          );
        },
      ),
    );
  }

  MaterialPageRoute _errorRoute() {
    // Handle unknown routes or errors
    return MaterialPageRoute(builder: (_) => Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(child: Text('Error: Route not found or invalid arguments')),
    ));
  }
}
