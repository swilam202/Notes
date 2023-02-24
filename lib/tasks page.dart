import 'package:flutter/material.dart';
import 'package:sqfl/sqlDB.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
          centerTitle: true,
          actions: [
            ElevatedButton(
              onPressed: () async {
                await sqlDB.initialDB();
              },
              child: const Text('init data'),
            ),
            ElevatedButton(
              onPressed: () async {
                await sqlDB.deleteAll();
              },
              child: const Text('delete all data'),
            ),
            ElevatedButton(
              onPressed: () async {
                int response = await sqlDB.insert({'title': 'A7A','note': 'kosom youssef askar'});
                print('+++++++++ $response ++++++++++');
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
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                     
                      child: Container(
                        width: double.infinity * 0.8,
                        height: 100,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(15),
                         color: Colors.blue.withOpacity(0.7)
                       ),

                        child: Text(snapshot.data![index]['note'],textAlign: TextAlign.center,),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
