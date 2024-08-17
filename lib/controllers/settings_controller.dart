import 'package:flutter/material.dart';

class SettingsController extends ChangeNotifier {
  bool isDarkTheme = false;

  static SettingsController instance = SettingsController();

  changeTheme(){
    isDarkTheme = !isDarkTheme;
    notifyListeners();    
  }
}