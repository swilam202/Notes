import 'package:get/get.dart';
import 'package:sqfl/db/sqlDB.dart';

class DataController extends GetxController {
  RxList tasks = [].obs;
  SqlDB sqlDB = SqlDB();
  RxInt selected = 0.obs;

  Future taskList() async {
    List task = await sqlDB.query();
    tasks.assignAll(task);
  }

  Future addTask(Map<String, Object> map) async {
    await sqlDB.insert(map);
    taskList();
  }

  Future updateTask(int id, Map<String, Object> map) async {
    await sqlDB.update(id, map);
    taskList();
  }

  Future deleteTask(int id) async {
    await sqlDB.delete(id);
    taskList();
  }

  Future deleteAllTasks() async {
    await sqlDB.deleteAll();
    taskList();
  }
}
