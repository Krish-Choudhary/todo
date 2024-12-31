import 'package:flutter/material.dart';

class NoTasksScreen extends StatelessWidget {
  const NoTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_tasks.png',
            width: 300,
          ),
          Text(
            'What do you want to do today?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 10),
          Text(
            'Tap + to add your tasks',
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }
}
