import 'package:flutter/material.dart';


class NavigationBottomButtons extends StatelessWidget {
  const NavigationBottomButtons({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/taskCreate');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 5, 63, 110),
              foregroundColor: Colors.white,
            ),
            child: const Icon(Icons.home),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/taskList');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 5, 63, 110),
              foregroundColor: Colors.white,
            ),
            child: const Icon(Icons.list_alt_rounded),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 5, 63, 110),
              foregroundColor: Colors.white,
            ),
            child: const Icon(Icons.person),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 5, 63, 110),
              foregroundColor: Colors.white,
            ),
            child: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
