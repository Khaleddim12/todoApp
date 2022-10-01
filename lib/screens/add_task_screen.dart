import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/taskController.dart';
import '../models/Task.dart';



class AddTaskScreen extends StatefulWidget {
  static String id = 'AddTaskScreen';

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final taskController = TextEditingController();
  String currTask = '';
  bool remindMe = false;
  DateTime? reminderDate;
  TimeOfDay? reminderTime;
  int id = 0;
  bool _validate = false;

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              controller: taskController,
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                currTask = newText;
              },
              decoration: InputDecoration(
                labelText: 'Enter the Value',
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SwitchListTile(
              value: remindMe,
              title: Text('Reminder'),
              onChanged: (newValue) async {
                if (newValue) {
                  reminderDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 2),
                  );

                  if (reminderDate == null) {
                    return;
                  }

                  reminderTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());

                  if (reminderDate != null && reminderTime != null) {
                    remindMe = newValue;
                  }
                } else {
                  reminderDate = null;
                  reminderTime = null;
                  remindMe = newValue;
                }

                print(reminderTime);
                print(reminderDate);

                setState(() {});
              },
              subtitle: Text('Remind me about this item'),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
                child: remindMe
                    ? Text('Reminder set at: ' +
                        DateTime(
                                reminderDate!.year,
                                reminderDate!.month,
                                reminderDate!.day,
                                reminderTime!.hour,
                                reminderTime!.minute)
                            .toString())
                    : null),
            SizedBox(
              height: 10.0,
            ),
            FlatButton(
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () {
                taskController.text.isEmpty
                    ? _validate = true
                    : _validate = false;
                if (!_validate) {
                  print(currTask);
                  Provider.of<TaskData>(context, listen: false).addTask(
                    Task(
                      title: currTask,
                      isChecked: false,
                      reminderDate: reminderDate == null
                          ? null
                          : reminderDate!.add(
                              Duration(
                                hours: reminderTime!.hour,
                                minutes: reminderTime!.minute,
                              ),
                            ),
                      reminderId: reminderDate != null ? id : null,
                    ),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('ToDo Added Successfully'),
                  ));
                } else {
                  Navigator.pop(context);
                  sleep(Duration(milliseconds: 30));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('cannot add empty ToDo!'),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
