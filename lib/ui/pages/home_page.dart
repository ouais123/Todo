import 'dart:developer';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    taskController.getTasks();
  }

  DateTime _selectedDate = DateTime.now();
  final TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 6),
          _showTasks(context),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext conrext) => AppBar(
        leading: IconButton(
          onPressed: () {
            ThemeServices().switchTheme();
          },
          icon: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round_outlined,
            size: 24,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: conrext.theme.backgroundColor,
        elevation: 0,
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage("images/person.jpeg"),
          ),
          SizedBox(
            width: 12,
          )
        ],
      );

  Widget _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: Themes().headingStyle,
              ),
              Text(
                "Today",
                style: Themes().subHeadingStyle,
              ),
            ],
          ),
          MyButton(
            label: "Add Task",
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  Widget _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: _selectedDate,
        width: 80,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (newDateTime) {
          setState(() {
            _selectedDate = newDateTime;
          });
        },
      ),
    );
  }

  Widget _showTasks(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (taskController.taskList.isNotEmpty) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              Task task = taskController.taskList[index];


              log(task.startTime!,name: "TEST");
          /*  var date = DateFormat.jm().parse(task.startTime!);
            var myTime = DateFormat("HH:mm").format(date);*/

              /*notifyHelper.displayNotification(
                title: task.title!, body: task.note!);*/
              /*notifyHelper.displayNotification(
                title: task.title!, body: task.note!);*//*
              notifyHelper.scheduledNotification(
                int.parse(myTime.toString().split(":")[0]),
                int.parse(myTime.toString().split(":")[1]),
                task,
              );*/
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1375),
                child: SlideAnimation(
                  horizontalOffset: 300,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {
                        _showBottomSheet(context, task);
                      },
                      child: TaskTile(task: task),
                    ),
                  ),
                ),
              );
            },
            itemCount: taskController.taskList.length,
          );
        } else {
          return _noTask();
        }
      }),
    );
  }

  Widget _noTask() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: SingleChildScrollView(
            child: Wrap(
              direction: SizeConfig.orientation == Orientation.landscape
                  ? Axis.vertical
                  : Axis.horizontal,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(height: 6)
                    : const SizedBox(height: 220),
                SvgPicture.asset(
                  "images/task.svg",
                  color: primaryClr.withOpacity(0.5),
                  height: 90,
                  semanticsLabel: "Task",
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    "Nisi sit velit fugiat nisi elit. \nDeserunt excepteur voluptate officia et. \nConsectetur dolore minim cillum proident dolor amet occaecat. \nConsectetur cillum do et ad esse esse ipsum. Labore ullamco qui pariatur exercitation ad velit.",
                    style: Themes().subTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(height: 120)
                    : const SizedBox(height: 180),
              ],
            ),
          ),
        )
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 8),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.3
                : SizeConfig.screenHeight * 0.39),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: "Task Completed",
                    onTap: () {
                      Get.back();
                    },
                    clr: primaryClr,
                  ),
            _buildBottomSheet(
              label: "Delete Task",
              onTap: () {
                Get.back();
              },
              clr: primaryClr,
            ),
            Divider(color: Get.isDarkMode ? Colors.grey : darkGreyClr),
            _buildBottomSheet(
              label: "Cancel Task",
              onTap: () {
                Get.back();
              },
              clr: primaryClr,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet({
    required String label,
    required Function onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? Themes().titleStyle
                : Themes().titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
