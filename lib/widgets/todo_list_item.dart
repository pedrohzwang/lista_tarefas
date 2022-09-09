import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas/models/task.dart';

// ignore: must_be_immutable
class TodoListItem extends StatefulWidget {
  TodoListItem(this.task, this.onDelete, this.onChanged, {Key? key})
      : super(key: key);

  Task task;
  Function(Task) onDelete;
  Function(Task) onChanged;

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Dismissible(
        key: Key(widget.task.key.toString()),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) => widget.onDelete(widget.task),
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.red,
          ),
          child: const Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.task.finished
                ? Colors.green
                : Theme.of(context).primaryColorDark,
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(formatter.format(widget.task.date)),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: widget.task.finished,
                    onChanged: (changed) {
                      setState(() {
                        widget.task.finished = changed!;
                      });
                      widget.onChanged(widget.task);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
