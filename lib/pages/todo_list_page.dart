import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoListPage> {
  final TextEditingController taskController = TextEditingController();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  List<Task> tasks = [];
  Task? deletedTask;
  int? indexDeletedTask;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Task task in tasks) TodoListItem(task, onDelete),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: SizedBox(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Você possui ${tasks.length} tarefas pendentes',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )),
        ),
        floatingActionButton: SizedBox(
          width: 75,
          height: 75,
          child: FloatingActionButton(
            onPressed: showAddTaskDialog,
            tooltip: 'Adicionar task',
            child: const Icon(Icons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  void showAddTaskDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Informe o título da tarefa'),
              content: TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  hintText: 'Adicionar uma tarefa',
                ),
                style: const TextStyle(fontSize: 15),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).disabledColor),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    addTask();
                  },
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColorLight),
                  child: const Text('Confirmar'),
                ),
              ],
            ));
  }

  void addTask() {
    String title = taskController.text;
    if (title.isNotEmpty) {
      setState(() {
        tasks.add(Task(title, DateTime.now()));
      });
      taskController.clear();
    }
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
            style:
                TextButton.styleFrom(primary: Theme.of(context).disabledColor),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTasks();
            },
            style:
                TextButton.styleFrom(primary: Theme.of(context).primaryColor),
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
        action: SnackBarAction(
          label: 'Desfazer',
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
