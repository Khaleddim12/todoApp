import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:todolist/db%20helper/database.dart';
import 'package:todolist/widgets/task_tile.dart';

import '../controllers/taskController.dart';
import '../models/Task.dart';
import '../screens/task_info_screen.dart';

String theme = '';
List tasksList = [];
bool initialised = false;

class TasksList extends StatelessWidget {

  final Database_todo _db = Database_todo();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _db.getTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Consumer<TaskData>(
            builder: (context, taskData, child) {
              if (!initialised) {
                if (theme == 'dark') {
                  taskData.toggleTheme();
                }
                taskData.init(tasksList);
                initialised = true;
              }
              if (taskData.tasks.isEmpty) {
                return const Center(
                  child: Text(
                    'Woohoo! You are all caught up!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 25.0,
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  final task = taskData.tasks[index];
                  return Dismissible(
                    key: UniqueKey(),
                    dismissThresholds: const {
                      DismissDirection.startToEnd: 0.6,
                      DismissDirection.endToStart: 0.6,
                    },
                    onDismissed: (direction) {
                      taskData.deleteTask(task);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Todo deleted successfully'),
                          action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                taskData.addTask(task, index: index);
                              }),
                        ),
                      );
                    },
                    child: TaskTile(
                      taskTitle: task.title!,
                      isChecked: task.isChecked!,
                      checkboxCallback: (checkboxState) {
                        taskData.toggleCheck(task);
                      },
                      edit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return TaskInfoScreen(
                              index: index,
                              task: Provider.of<TaskData>(context).tasks[index],
                            );
                          }),
                        );
                      },
                    ),
                  );
                },
                itemCount: taskData.taskCount,
              );
            },
          );
        }
      },
    );
  }
}
