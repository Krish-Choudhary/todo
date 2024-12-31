import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/screens/posts_screen.dart';
import 'package:todo/constants/category_constants.dart';
import 'package:todo/screens/no_tasks_screen.dart';
import 'package:todo/providers/task_list_provider.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/screens/tasks_screen.dart';
import 'package:todo/providers/theme_provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskList = Provider.of<TaskListModel>(context);
    DateTime? selectedDate;
    final themeMode = Theme.of(context).brightness;
    TimeOfDay? selectedTime;
    String? selectedCategory;
    int selectedPriority = 10;

    void presentDateTimePicker() async {
      final now = DateTime.now();
      final lastDate = DateTime(now.year, now.month + 1, now.day);
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? now,
        firstDate: now,
        lastDate: lastDate,
      );
      final pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
      );

      selectedDate = pickedDate;
      selectedTime = pickedTime;
    }

    void categoryDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Choose Category'),
            content: SizedBox(
              width: 300,
              height: 250,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      selectedCategory = categories[index];
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: categoryColors[index],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              Icon(categoryIcons[index], color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(categories[index]),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    void priorityDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Choose Category'),
            content: SizedBox(
              width: 300,
              height: 250,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 65,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 15,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      selectedPriority = index + 1;
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.flag_outlined,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                            Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    void addNewTask() {
      String newTaskTitle = '';
      String newTaskDescription = '';
      selectedPriority = 10;
      selectedCategory = null;
      selectedTime = null;
      selectedDate = null;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Add Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      newTaskTitle = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      newTaskDescription = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        onPressed: presentDateTimePicker,
                        icon: Icon(
                          Icons.timer_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      IconButton(
                        onPressed: categoryDialog,
                        icon: Icon(
                          Icons.label_important_outline,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      IconButton(
                        onPressed: priorityDialog,
                        icon: Icon(
                          Icons.flag_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          if (newTaskTitle.isNotEmpty) {
                            final newTask = Task(
                              title: newTaskTitle,
                              description: newTaskDescription,
                              category: selectedCategory,
                              date: selectedDate,
                              time: selectedTime,
                              priority: selectedPriority,
                            );
                            Provider.of<TaskListModel>(context, listen: false)
                                .addTask(newTask);
                            Navigator.pop(context);
                          } else {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Task title can\'t be empty',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.errorContainer,
                            ));
                          }
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    void toggleTheme() {
      final newThemeMode =
          themeMode == Brightness.light ? Brightness.dark : Brightness.light;
      Provider.of<ThemeProvider>(context, listen: false).setTheme(newThemeMode);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('To Do', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        leading: IconButton(
            onPressed: toggleTheme, icon: Icon(Icons.wb_sunny_outlined)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PostsScreen()));
              },
              icon: Icon(Icons.unfold_more_double_outlined))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: addNewTask,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
      body: taskList.tasks.isEmpty
          ? const NoTasksScreen()
          : TasksScreen(tasksProvided: taskList.tasks),
    );
  }
}
