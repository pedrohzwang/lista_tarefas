import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas/hive/hive_controller.dart';
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

  Task? deletedTask;
  int? indexDeletedTask;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

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
                  child: ValueListenableBuilder(
                    valueListenable: taskBox.listenable(),
                    builder: (context, Box<Task> box, _) {
                      if (box.values.isEmpty) {
                        return const Center();
                      }
                      return ListView.builder(
                        itemCount: box.values.length,
                        itemBuilder: (context, index) {
                          return TodoListItem(
                              box.getAt(index)!, onDelete, onFinished);
                        },
                      );
                    },
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
                    child: ValueListenableBuilder(
                      valueListenable: taskBox.listenable(),
                      builder: (context, Box<Task> box, _) {
                        int pendentes = taskBox.values
                            .where((task) => task.finished == false)
                            .length;
                        return Text(
                          pendentes > 0
                              ? '$pendentes tarefa${pendentes > 1 ? 's' : ''} pendente${pendentes > 1 ? 's' : ''}'
                              : 'Sem tarefas pendentes',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
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
              child: const Icon(Icons.add),
            )
            //     ExpandableFab(
            //   distance: 100,
            //   initialOpen: false,
            //   children: [
            //     FloatingActionButton(
            //       onPressed: showAddTaskDialog,
            //       child: const Icon(Icons.delete),
            //     ),
            //     ActionButton(
            //       onPressed: showAddTaskDialog,
            //       icon: const Icon(Icons.delete),
            //     ),
            //   ],
            // ),
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
                autofocus: true,
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
                    taskController.clear();
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
      taskBox.add(Task(title, DateTime.now()));
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
    taskBox.deleteAll(taskBox.keys);
  }

  void onDelete(Task task) {
    final deletedKey = task.key;
    task.delete();

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
            taskBox.put(deletedKey, task);
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void onFinished(Task task) {
    task.save();
  }
}
