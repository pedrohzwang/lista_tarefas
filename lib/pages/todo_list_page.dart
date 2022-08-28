import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoListPage> {
  final TextEditingController taskController = TextEditingController();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  List<String> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black54,
        child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: taskController,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            hintText: 'Adicionar uma tarefa',
                            hintStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red.shade400,
                                width: 5,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          String task = taskController.text;
                          if (task.isNotEmpty) {
                            setState(() {
                              tasks.add(taskController.text);
                            });
                            taskController.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade400,
                            padding: const EdgeInsets.all(16)),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (String task in tasks)
                          ListTile(
                            title: Text(
                              task,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 19),
                            ),
                            subtitle: Text(
                              formatter.format(DateTime.now()),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Você possui ${tasks.length} tarefas pendentes',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tasks.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade400,
                            padding: const EdgeInsets.all(16)),
                        child: const Text('Limpar tudo'),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
