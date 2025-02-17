import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants/category_constants.dart';
import 'package:todo/providers/task_list_provider.dart';
import 'package:todo/models/task_model.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({super.key, required this.index});

  final int index;

  String getMonth(int month) {
    if (month == 1) {
      return 'Jan';
    } else if (month == 2) {
      return 'Feb';
    } else if (month == 3) {
      return 'Mar';
    } else if (month == 4) {
      return 'Apr';
    } else if (month == 5) {
      return 'May';
    } else if (month == 6) {
      return 'Jun';
    } else if (month == 7) {
      return 'Jul';
    } else if (month == 8) {
      return 'Aug';
    } else if (month == 9) {
      return 'Sep';
    } else if (month == 10) {
      return 'Oct';
    } else if (month == 11) {
      return 'Nov';
    } else {
      return 'Dec';
    }
  }

  String getFormattedDateandTime(DateTime date, TimeOfDay? time) {
    String ans = '';
    DateTime now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      ans = 'Today';
    } else if (date.day == now.day + 1 &&
        date.month == now.month &&
        date.year == now.year) {
      ans = 'Tomorrow';
    } else {
      ans = '${date.day} ${getMonth(date.month)}';
    }
    if (time != null) {
      ans = '$ans ${time.hour}:${time.minute}';
    }
    return ans;
  }

  @override
  Widget build(BuildContext context) {
    final taskList = Provider.of<TaskListModel>(context);
    final task = taskList.tasks[index];
    int categoryIndex = categories.indexOf(task.category ?? '');

    return Dismissible(
      key: ValueKey<Task>(task), // Important for Dismissible
      direction: DismissDirection.startToEnd, // Swipe from left to right
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        taskList.removeTask(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${task.title} deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                taskList.addTask(task);
              },
            ),
          ),
        );
      },
      child: ListTile(
        tileColor: Theme.of(context).focusColor,
        leading: Checkbox(
          value: task.isChecked,
          onChanged: (val) => taskList.toggleTaskCheck(index),
          shape: const CircleBorder(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(task.title),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (task.date != null)
              Expanded(
                  child: Text(getFormattedDateandTime(task.date!, task.time))),
            const Spacer(),
            categoryIndex != -1
                ? Chip(
                    backgroundColor: categoryColors[categoryIndex],
                    label: Row(
                      children: [
                        Icon(
                          categoryIcons[categoryIndex],
                          color: Colors.black,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          task.category.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Spacer(),
            const SizedBox(width: 8),
            Chip(
              label: Row(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    task.priority.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
