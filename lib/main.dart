import 'package:flutter/material.dart';
import 'package:lista_tarefas/pages/todo_list_page.dart';
import 'package:lista_tarefas/theme/theme.dart';

void main() {
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
