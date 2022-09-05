import 'package:hive_flutter/hive_flutter.dart';
import 'package:lista_tarefas/models/task.dart';

late Box<Task> taskBox;

void registerAdapters() {
  Hive.registerAdapter(TaskAdapter());
}

Future<void> openBoxes() async {
  taskBox = await Hive.openBox<Task>('taskBox');
  return;
}
