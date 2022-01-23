import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  String _startTime = DateFormat("hh: mm a").format(DateTime.now()).toString();
  String _endTime = DateFormat("hh: mm a")
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();

  int _selectedRemind = 5;

  List<int> remindList = [5, 10, 15, 20];

  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];

  int _seclectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  "Add Task",
                  style: Themes().headingStyle,
                ),
              ),
              InputField(
                title: "Title",
                hint: "Enter title here",
                controller: _titleController,
              ),
              InputField(
                title: "Title",
                hint: "Enter title here",
                controller: _noteController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser(context);
                  },
                  icon: const Icon(
                    Icons.date_range_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(context, isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(context, isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: Row(
                  children: [
                    DropdownButton<int>(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                      items: remindList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                "$e",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.grey),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRemind = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
              InputField(
                title: "Repeat",
                hint: "$_selectedRepeat minutes early",
                widget: Row(
                  children: [
                    DropdownButton<String>(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                      items: repeatList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.grey),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRepeat = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text("Color", style: Themes().titleStyle),
                      Wrap(
                        children: List.generate(
                          3,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _seclectedColor = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundColor: index == 0
                                    ? primaryClr
                                    : index == 1
                                        ? pinkClr
                                        : orangeClr,
                                child: _seclectedColor == index
                                    ? const Icon(
                                        Icons.done,
                                        size: 24,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  MyButton(
                    label: "create Task",
                    onTap: () {
                      _validDate();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext conrext) => AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: primaryClr,
          ),
        ),
        backgroundColor: conrext.theme.backgroundColor,
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage("images/person.jpeg"),
          ),
          SizedBox(
            width: 12,
          )
        ],
      );

  void _getDateFromUser(BuildContext context) async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (_pickedDate != null) setState(() => _selectedDate = _pickedDate);
  }

  void _getTimeFromUser(BuildContext context,
      {required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (isStartTime) {
      if (_pickedTime != null) {
        String formatedTime = _pickedTime.format(context);
        setState(() => _startTime = formatedTime);
      }
    } else {
      if (_pickedTime != null) {
        String formatedTime = _pickedTime.format(context);
        setState(() => _endTime = formatedTime);
      }
    }
  }

  _validDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "required",
        "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    } else {
      Get.snackbar("required", "ERROR");
    }
  }

  void _addTasksToDb() async {
    int value = await taskController.addTask(
        task: Task(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _seclectedColor,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
    ));

    log(value.toString(), name: "Test");
  }
}
