import 'package:flutter/material.dart';
import 'package:sqfl/add%20task%20page.dart';

import 'control page.dart';
import 'tasks page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskPage(),
      routes: {
        'add' : (context)=>AddTask(),
        'task' : (context)=>TaskPage(),
      },
    );
  }
}
