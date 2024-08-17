import 'package:flutter/material.dart';
import 'package:mobile_task_track/models/user_provider.dart';
import 'package:mobile_task_track/widgets/app_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (_) => UserProvider(), child: const AppWidget()),
  );
}
