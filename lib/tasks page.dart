import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqfl/controller/dataController.dart';
import 'dart:math';
import 'db/sqlDB.dart';

class TaskPage extends StatefulWidget {
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  SqlDB sqlDB = SqlDB();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sqlDB.initialDB();
  }

  GlobalKey key = GlobalKey();
  DataController controller = Get.put(DataController());

  List colors = [
    const Color.fromRGBO(238, 174, 174, 1.0),
    const Color.fromRGBO(181, 239, 126, 1.0),
    const Color.fromRGBO(226, 239, 142, 1.0),
    const Color.fromRGBO(255, 227, 120, 1.0),
    const Color.fromRGBO(196, 234, 234, 1.0),
  ];

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  Random r = Random();
  int colorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Tasks',
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {
              Get.defaultDialog(
                backgroundColor: const Color.fromRGBO(52, 52, 52, 0.9),
                title: 'Are you sure you want to delete all tasks?',
                titlePadding: const EdgeInsets.only(
                    top: 25, left: 20, right: 20, bottom: 15),
                content: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          controller.deleteAllTask();
                          Get.back();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            label: const Text(
              'Delete All',
              style: TextStyle(color: Colors.red),
            ),
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.delayed(
          const Duration(milliseconds: 1500),
        ),
        builder: (_, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : Obx(
                () {
                  controller.taskList();
                  return controller.tasks.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.tasks.length,
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.bottomSheet(
                                  ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Text(
                                          controller.tasks[index]['title'],
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 5,
                                        height: 5,
                                        indent: 20,
                                        endIndent: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Text(
                                          controller.tasks[index]['note'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor:
                                      colors[controller.tasks[index]['color']],
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: colors[controller.tasks[index]
                                        ['color']],
                                  ),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 17,
                                            top: 17,
                                            right: 17,
                                            bottom: 25),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              controller.tasks[index]['title'],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 35,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text(
                                          controller.tasks[index]['note'],
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.fade,
                                          softWrap: true,
                                          maxLines: 3,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              sheet(
                                                controller.tasks[index]
                                                    ['title'],
                                                controller.tasks[index]['note'],
                                                0,
                                                controller.tasks[index]['id'],
                                                'Update task',
                                                controller.tasks[index]['color'],
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.mode_rounded,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              controller.deleteTask(controller
                                                  .tasks[index]['id']);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'There is no notes for today',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(Icons.add),
          onPressed: () {
            titleController.text = '';
            noteController.text = '';
            sheet('', '', 1, 1, 'New Task',0);
          }),
    );
  }

  warning() {
    Get.snackbar(
      'Warning',
      "All fileds mustn't be null",
      icon: const Icon(
        Icons.warning_amber,
        color: Colors.red,
      ),
      colorText: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
    );
  }

  sheet(String one, String two, int index, int id, String text,int color) {
    titleController.text = one;
    noteController.text = two;
    controller.selected.value = color;
    Get.bottomSheet(
      Obx(
        () => Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      colors.length,
                      (index) => GestureDetector(
                        onTap: () => controller.selected.value = index,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CircleAvatar(
                            minRadius: 15,
                            backgroundColor: colors[index],
                            child: controller.selected.value == index
                                ? const Icon(Icons.check)
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: key,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter Title ',
                        hintStyle: const TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      controller: titleController,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter your notes....',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 50, horizontal: 15),
                          hintStyle: const TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        controller: noteController,
                      ),
                    ),
                    OutlinedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(119, 34, 34, 1.0),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 70,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (titleController.text.isNotEmpty &&
                            noteController.text.isNotEmpty) {
                          if (index == 1) {
                            await controller.addTask(
                              {
                                'title': titleController.text,
                                'note': noteController.text,
                                'color': controller.selected.value,
                              },
                            );
                          } else {
                            await controller.updateTask(id, {
                              'title': titleController.text,
                              'note': noteController.text,
                              'color': controller.selected.value,
                            });
                          }

                          Get.back();
                        } else {
                          warning();
                        }
                      },
                      child: Text(text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(52, 52, 52, 1.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
