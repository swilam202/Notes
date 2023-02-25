import 'package:flutter/material.dart';
import 'package:sqfl/sqlDB.dart';
import 'dart:math';

class AddTask extends StatelessWidget {
  SqlDB sqlDB = SqlDB();
  GlobalKey key1 = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  Random r = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Form(
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
                    if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
                    int response = await sqlDB.insert(
                      {
                        'title': titleController.text,
                        'note': noteController.text,
                        'color': r.nextInt(5)
                      },
                    );

                      Navigator.of(context).pushReplacementNamed('task');

                    print('+++++++++ $response ++++++++++');
                    }
                    else{
                      /// get.Snack
                    }
                  },
                  child: const Text('insert data'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
