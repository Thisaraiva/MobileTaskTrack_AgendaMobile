import 'package:flutter/material.dart';
import 'package:mobile_task_track/controllers/settings_controller.dart';
import 'package:mobile_task_track/widgets/navigation_bottom_buttons.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 63, 110),
        title: const Text('Preferências'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              const Text(
                'Tema',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Switch(
                  value: SettingsController.instance.isDarkTheme,
                  onChanged: (value) {
                    setState(
                      () {
                        SettingsController.instance.changeTheme();
                      },
                    );
                  },
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
