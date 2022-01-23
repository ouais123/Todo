import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask({required Task task}) {
    return DBHelper.insert(task);
  }

  Future<void> getTasks() async {
    List<Map<String, dynamic>> list = await DBHelper.query();
    taskList.assignAll(list.map((e) => Task.fromJosn(e)).toList());
  }

  void deleteTasks(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.upate(id);
    getTasks();
  }
}
