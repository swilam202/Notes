import 'package:flutter/material.dart';
import 'package:sqfl/sqlDB.dart';
import 'dart:math';

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
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  List colors = [
    const Color.fromRGBO(238, 174, 174, 1.0),
    const Color.fromRGBO(181, 239, 126, 1.0),
    const Color.fromRGBO(226, 239, 142, 1.0),
    const Color.fromRGBO(255, 227, 120, 1.0),
    const Color.fromRGBO(196, 234, 234, 1.0),
  ];

  int current = 1;
  Random r = Random();
  int colorIndex = 0;

  void switchIndex(int index) {
    setState(() => current = index);
  }

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
          ElevatedButton(
            onPressed: () async {
              await sqlDB.initialDB();
              setState(() {});
            },
            child: const Text('init data'),
          ),
          ElevatedButton(
            onPressed: () async {
              await sqlDB.deleteAll();
              setState(() {});
            },
            child: const Text('delete all data'),
          ),
          ElevatedButton(
            onPressed: () async {
              int response = await sqlDB.insert({
                'title': 'Testing Testing one two three',
                'note': 'o ui jify uifdj iye uiodj iiueyf8ueiouef oi eA7A',
                'color': r.nextInt(colors.length)
              });
              print('+++++++++ $response ++++++++++');
              setState(() {});
            },
            child: const Text('insert data'),
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
                  onTap: () {},
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: colors[snapshot.data![index]['color']]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
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
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              snapshot.data![index]['note'],
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.mode_rounded,color: Colors.blue,),
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
        onPressed: () => showBottomSheet(
            context: context,
            builder: (_) {
              return Expanded(
                child: Form(
                  key: key1,
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

                            Navigator.of(context).pushReplacementNamed('task');

                            print('+++++++++ $response ++++++++++');
                          } else {
                            /// get.Snack
                          }
                        },
                        child: const Text('insert data'),
                      ),
                    ],
                  ),
                ),
              );
            }),
        child: const Icon(Icons.add),
      ),
    );
  }
}
