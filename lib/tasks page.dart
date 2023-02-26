import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqfl/sqlDB.dart';
import 'dart:math';

import 'add task page.dart';

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
    sqlDB.db;
  }

  Future<List> taskList() async {
    List list = await sqlDB.query();
    return list;
  }

  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();

  List colors = [
    const Color.fromRGBO(238, 174, 174, 1.0),
    const Color.fromRGBO(181, 239, 126, 1.0),
    const Color.fromRGBO(226, 239, 142, 1.0),
    const Color.fromRGBO(255, 227, 120, 1.0),
    const Color.fromRGBO(196, 234, 234, 1.0),
  ];

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController titleController1 = TextEditingController();
  TextEditingController noteController1 = TextEditingController();

  Random r = Random();
  int colorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: 'Are you sure you want to delete all tasks?',
                content: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          sqlDB.deleteAll();
                          sqlDB.initialDB();
                          setState(() {});
                          Get.back();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
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
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: taskList(),
        builder: (_, snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                snapshot.data![index]['title'],
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Divider(
                              thickness: 5,
                              height: 5,
                              indent: 20,
                              endIndent: 20,
                            ),
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  snapshot.data![index]['note'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          ],
                        ),
                        backgroundColor:
                            colors[snapshot.data![index]['color']]);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: colors[snapshot.data![index]['color']]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(17),
                            child: Text(
                              snapshot.data![index]['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                snapshot.data![index]['note'],
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.fade,
                                softWrap: true,
                                maxLines: 8,
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  titleController1.text =
                                      snapshot.data![index]['title'];
                                  noteController1.text =
                                      snapshot.data![index]['note'];
                                  Get.bottomSheet(
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: ListView(
                                        children: [
                                          Form(
                                            key: key1,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'Enter Title',
                                                  ),
                                                  controller: titleController1,
                                                ),
                                                TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'Enter note',
                                                  ),
                                                  controller: noteController1,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    int response = await sqlDB
                                                        .update(
                                                            snapshot.data![
                                                                index]['id'],
                                                            {
                                                          'title':
                                                              titleController1
                                                                  .text,
                                                          'note':
                                                              noteController1
                                                                  .text,
                                                        });
                                                    setState(() {});

                                                    Get.back();
                                                  },
                                                  child:
                                                      const Text('Edit data'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                  );
                                },
                                icon: const Icon(
                                  Icons.mode_rounded,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  sqlDB.delete(snapshot.data![index]['id']);
                                  setState(() {});
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
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Get.bottomSheet(
              Padding(
                padding: const EdgeInsets.all(18),
                child: ListView(
                  children: [
                    Form(
                      key: key2,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Enter Title',
                            ),
                            controller: titleController,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Enter note',
                            ),
                            controller: noteController,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (titleController.text.isNotEmpty &&
                                  noteController.text.isNotEmpty) {
                                int response = await sqlDB.insert(
                                  {
                                    'title': titleController.text,
                                    'note': noteController.text,
                                    'color': r.nextInt(5)
                                  },
                                );
                                setState(() {});
                                Get.back();
                              } else {
                                Get.snackbar(
                                    'Warning', "All fileds mustn't be null",
                                    icon: const Icon(
                                      Icons.warning_amber,
                                      color: Colors.red,
                                    ),
                                    colorText: Colors.red,
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                            },
                            child: const Text('insert data'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            );
          }),
    );
  }
}
