import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoListPage> {
  final TextEditingController taskController = TextEditingController();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  List<Task> tasks = [];
  Task? deletedTask;
  int? indexDeletedTask;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black54,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                          String title = taskController.text;
                          if (title.isNotEmpty) {
                            setState(() {
                              tasks.add(Task(title, DateTime.now()));
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
                        for (Task task in tasks) TodoListItem(task, onDelete),
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
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: showDeleteAllTasksConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade400,
                            padding: const EdgeInsets.all(16)),
                        child: const Text('Limpar tudo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteAllTasksConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar tudo?'),
        content:
            const Text('Você tem certeza que deseja limpar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(primary: Colors.black54),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTasks();
            },
            style: TextButton.styleFrom(primary: Colors.red.shade400),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void deleteAllTasks() {
    setState(() {
      tasks.clear();
    });
  }

  void onDelete(Task task) {
    setState(() {
      deletedTask = task;
      indexDeletedTask = tasks.indexOf(task);
      tasks.remove(task);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Tarefa removida com sucesso!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black54,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.red.shade400,
          onPressed: () {
            setState(() {
              tasks.insert(indexDeletedTask!, deletedTask!);
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
