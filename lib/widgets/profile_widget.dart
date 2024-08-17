import 'package:flutter/material.dart';

class ProfileInfoField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ProfileInfoField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        //color: const Color.fromRGBO(67, 54, 51, 100),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
