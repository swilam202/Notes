import 'package:flutter/material.dart';
import 'package:sqfl/sqlDB.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

   SqlDB sqlDB = SqlDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async{
                await sqlDB.initialDB();
              },
              child: const Text('init data'),
            ),
            ElevatedButton(
              onPressed: () async{
                await sqlDB.deleteAll();
              },
              child: const Text('delete all data'),
            ),
            ElevatedButton(
              onPressed: () async{
                int response = await sqlDB.insertData('INSERT INTO notes (note) VALUES ("dek")');
                print('+++++++++ $response ++++++++++');
              },
              child: const Text('insert data'),
            ),
            ElevatedButton(
              onPressed: () async{
                List response = await sqlDB.queryData('SELECT * FROM notes ');
                print('++++++++ $response ++++++++++');
              },
              child: const Text('read data'),
            ),
            ElevatedButton(
              onPressed: () async{
                int response = await sqlDB.delete(5);
                print('++++++++ $response ++++++++++');
              },
              child: const Text('delete data'),
            ),
            ElevatedButton(
              onPressed: () async{
                int response = await sqlDB.update(6, {'note': 'daret y seya3'});
                print('++++++++ $response ++++++++++');
              },
              child: const Text('update data'),
            ),
          ],
        ),
      ),
    );
  }
}
