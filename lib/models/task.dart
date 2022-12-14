import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  Task(this.title, this.date, {this.finished = false});

  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime date;

  @HiveField(2, defaultValue: false)
  bool finished;
}
