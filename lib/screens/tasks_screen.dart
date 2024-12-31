import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/components/todo_list_item.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key, required this.tasksProvided});
  final List<Task> tasksProvided;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tasksProvided.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 8,
            ),
            child: TodoListItem(index: index),
          );
        });
  }
}
