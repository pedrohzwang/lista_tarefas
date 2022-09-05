import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lista_tarefas/hive/hive_controller.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/pages/todo_list_page.dart';
import 'package:lista_tarefas/theme/theme.dart';

void main() async {
  await Hive.initFlutter();
  registerAdapters();
  await openBoxes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const TodoListPage(),
    );
  }
}
