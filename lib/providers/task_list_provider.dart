import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class TaskListModel extends ChangeNotifier {
  List<Task> _tasks = [];
  late Database _database;

  List<Task> get tasks => _tasks;

  Future<void> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tasks.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, category TEXT, date INTEGER, time INTEGER, priority INTEGER, isChecked INTEGER)',
        );
      },
    );
    print('databse initialised');

    await _loadTasksFromDatabase();
  }

  Future<void> _loadTasksFromDatabase() async {
    final List<Map<String, dynamic>> maps = await _database.query('tasks');
    _tasks = List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        category: maps[i]['category'],
        date: maps[i]['date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(maps[i]['date'])
            : null,
        time: maps[i]['time'] != null
            ? TimeOfDay.fromDateTime(
                DateTime.fromMillisecondsSinceEpoch(maps[i]['time']))
            : null,
        priority: maps[i]['priority'],
        isChecked: maps[i]['isChecked'] == 1,
      );
    });
    _tasks.sort((a, b) => a.priority.compareTo(b.priority));
    print('tasks loaded');
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final id = await _database.insert('tasks', task.toMap());
    final newTask = task.copyWith(id: id);
    _tasks.add(newTask);
    _tasks.sort((a, b) => a.priority.compareTo(b.priority));
    print('new task added');
    notifyListeners();
  }

  Future<void> toggleTaskCheck(int index) async {
    final task = _tasks[index];
    final updatedTask = task.copyWith(isChecked: !task.isChecked);
    await _database.update(
      'tasks',
      updatedTask.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    _tasks[index] = updatedTask;
    notifyListeners();
  }

  Future<void> removeTask(int index) async {
    final taskToRemove = _tasks[index];
    await _database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskToRemove.id],
    );
    _tasks.removeAt(index);
    notifyListeners();
  }
}

extension TaskToMap on Task {
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'date': date?.millisecondsSinceEpoch,
      'time': time != null
          ? DateTime(2024, 1, 1, time!.hour, time!.minute)
              .millisecondsSinceEpoch
          : null,
      'priority': priority,
      'isChecked': isChecked ? 1 : 0,
    };
  }
}
