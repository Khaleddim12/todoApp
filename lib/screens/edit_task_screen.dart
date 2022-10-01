import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../controllers/taskController.dart';
import '../models/Task.dart';
import '../widgets/option_button.dart';

class TaskEditScreen extends StatefulWidget {
  final Task task;
  TaskEditScreen({required this.task});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final titleController = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  late String? newTaskTitle;
  late bool? newTaskIsChecked;
  bool? dropDownVal = false;
  late DateTime reminderDate;
  late String reminderDateString;
  DateTime? newTaskReminderDate;

  @override
  void initState() {
    super.initState();
    titleController.value = TextEditingValue(
      text: widget.task.title.toString(),
    );
    newTaskTitle = widget.task.title;
    dropDownVal = widget.task.isChecked;
    newTaskIsChecked = widget.task.isChecked;
    reminderDate = widget.task.reminderDate!;
    newTaskReminderDate = reminderDate;
    reminderDateString = reminderDate.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlueAccent,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlatButton(
                child: const Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: Colors.white,
                  size: 40.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 30.0,
                  right: 30.0,
                  bottom: 30.0,
                ),
                child: const Text(
                  'Edit Task',
                  style: TextStyle(
                    fontSize: 50.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        left: 30.0,
                        right: 30.0,
                        bottom: 30.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  const Text(
                                    'Title: ',
                                    style: kTaskInfoTextStyle,
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (newValue) {
                                        newTaskTitle = newValue;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Enter the Value',
                                        errorText: _validate
                                            ? 'Value Can\'t Be Empty'
                                            : null,
                                      ),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      controller: titleController,
                                      style: kTaskInfoTextStyle,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            children: <Widget>[
                              const Text(
                                'Task is Done? : ',
                                style: kTaskInfoTextStyle,
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              DropdownButton<bool>(
                                value: dropDownVal,
                                style: kTaskInfoTextStyle.copyWith(
                                    color: Colors.black),
                                items: [true, false]
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e.toString(),
                                          style: kTaskInfoTextStyle.copyWith(
                                              color: Colors.black),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (newVal) {
                                  setState(
                                    () {
                                      dropDownVal = newVal!;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Row(
                            children: <Widget>[
                              const Text(
                                'Reminder: ',
                                style: kTaskInfoTextStyle,
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                child: FlatButton(
                                  color: Colors.lightBlueAccent,
                                  onPressed: () async {
                                    newTaskReminderDate = (await showDatePicker(
                                      context: context,
                                      initialDate: reminderDate != null
                                          ? reminderDate
                                          : DateTime.now(),
                                      firstDate: reminderDate != null
                                          ? reminderDate
                                          : DateTime.now(),
                                      lastDate:
                                          DateTime(DateTime.now().year + 2),
                                    ))!;
                                    if (newTaskReminderDate == null) {
                                      return;
                                    }
                                    TimeOfDay? reminderTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: reminderDate != null
                                          ? TimeOfDay(
                                              hour: reminderDate.hour,
                                              minute: reminderDate.minute,
                                            )
                                          : const TimeOfDay(
                                              hour: 0,
                                              minute: 0,
                                            ),
                                    );
                                    newTaskReminderDate =
                                        newTaskReminderDate!.add(
                                      Duration(
                                        hours: reminderTime!.hour,
                                        minutes: reminderTime.minute,
                                      ),
                                    );
                                    setState(() {
                                      reminderDateString =
                                          newTaskReminderDate.toString();
                                    });
                                  },
                                  child: Text(
                                    newTaskReminderDate != null
                                        ? reminderDateString.substring(
                                            0, reminderDateString.length - 7)
                                        : 'Not Set',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  setState(() {
                                    newTaskReminderDate = null;
                                  });
                                },
                                color: Colors.red,
                              )
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            child: OptionButton(
                              title: "Save Changes",
                              onPressed: () {
                                setState(() {
                                  titleController.text.isEmpty
                                      ? _validate = true
                                      : _validate = false;
                                });
                                if (newTaskTitle == widget.task.title &&
                                    newTaskIsChecked == dropDownVal) {
                                  Navigator.pop(context);
                                  return;
                                }
                                Provider.of<TaskData>(context, listen: false)
                                    .modifyTask(
                                  widget.task,
                                  Task(
                                      title: newTaskTitle,
                                      isChecked: dropDownVal),
                                );
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
