import 'package:flutter/material.dart';

class Task {
  Task(
      {required this.title,
      this.id,
      this.category,
      this.description,
      this.date,
      this.time,
      required this.priority,
      this.isChecked = false});
  String title;
  final int? id;
  String? description;
  DateTime? date;
  TimeOfDay? time;
  int priority;
  String? category;
  bool isChecked;

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? time,
    int? priority,
    String? category,
    bool? isChecked,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
