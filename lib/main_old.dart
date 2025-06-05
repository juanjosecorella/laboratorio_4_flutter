import 'package:flutter/material.dart';
import 'package:laboratorio_4_flutter/db/db_helper.dart';
import 'package:laboratorio_4_flutter/models/task.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            Placeholder(),
            ElevatedButton(
              onPressed: () {
                showDialog(context: context, builder: (context) => AddDialog());
              },
              child: Text("Añadir tarea"),
            ),
          ],
        ),
      ),
    );
  }
}

class AddDialog extends StatefulWidget {
  const AddDialog({super.key});

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final _titleController = TextEditingController();
  final _dbHelper = DBHelper();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Añadir botón"),
      actionsAlignment: MainAxisAlignment.spaceAround,
      content: Form(
        child: TextFormField(
          controller: _titleController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Campo requerido";
            }

            return null;
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () async {
            await _dbHelper.insertTask(_titleController.text);
            if (!context.mounted) {
              return;
            }
            Navigator.pop(context);
          },
          child: Text("Añadir"),
        ),
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card();
  }
}
