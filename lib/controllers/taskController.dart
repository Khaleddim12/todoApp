import 'dart:collection';

import 'package:flutter/material.dart';


import 'package:todolist/db%20helper/database.dart';

import '../models/Task.dart';

class TaskData extends ChangeNotifier {
  ThemeData currTheme = ThemeData.light();

  final Database_todo _db = Database_todo();

  List<Task> _tasks = [];

  Future initialise() async {

    _tasks = await _db.getTasks();

  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  void clearTotos() {
    _tasks = [];
    _db.empty();
    notifyListeners();
  }

  Future<void> addTask(Task task, {int? index}) async {

    if (index != null) {
      _tasks.insert(index, task);
    } else {
      _tasks.add(task);
    }
    await _db.insertTask(task);
    notifyListeners();
  }

  Future<void> toggleCheck(Task task) async {
    task.toggleDone();
    _db.toggleCheck(task);
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    _tasks.remove(task);
    _db.deleteTask(task.id!.toInt());
    notifyListeners();
  }

  Future<void> modifyTask(Task original, Task newTask) async {
    for (int i = 0; i < _tasks.length; i++) {
      if (_tasks[i] == original) {
        _tasks[i] = newTask;
        break;
      }
    }
    _db.updateTask(original);
    notifyListeners();
  }

  int get taskCount {
    return _tasks.length;
  }

  Future<void> init(item) async {
    if (item != null && item.length > 0) {
      _tasks.clear();
      for (Map e in item) {
        _tasks.add(Task(
            title: e['title'],
            isChecked: e['isChecked'],
            reminderDate: e['reminderDate'] != null
                ? DateTime.parse(e['reminderDate'])
                : null,
            reminderId: e['reminderId']));
      }
    }
  }

  Future<void> toggleTheme() async {
    if (currTheme == ThemeData.light()) {
      currTheme = ThemeData.dark();
    } else {
      currTheme = ThemeData.light();
    }
    notifyListeners();
  }
}
