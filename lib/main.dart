import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqfl/sqlDB.dart';
import 'tasks page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SqlDB sqlDB = SqlDB();
  sqlDB.db;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskPage(),
    );
  }
}
