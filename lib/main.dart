import 'package:flutter/material.dart';
import 'db/db_helper.dart';
import 'models/task.dart';

void main(){
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini ToDo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController _controller = TextEditingController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await dbHelper.getTasks();
    setState(() {
      tasks = data;
    });
  }

  Future<void> _addTask() async {
    final title = _controller.text;
    if (title.isNotEmpty) {
      await dbHelper.insertTask(_controller.text);
      _controller.clear();
      _loadTasks();
    }
  }

  Future<void> _confirmTask(int id) async {
    await dbHelper.confirmTask(id);
    _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini ToDo App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nueva tarea',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.blue,
                  onPressed: _addTask,
                ),
              ),
              onSubmitted: (_) => _addTask(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  tasks.isEmpty
                      ? const Text('No hay tareas')
                      : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Dismissible(
                            key: Key(task.id.toString()),
                            onDismissed: (_) => _deleteTask(task.id!),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: Card(
                              color:
                                  task.confirmed ? Colors.green : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            task.confirmed
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          task.confirmed
                                              ? 'Confirmada'
                                              : 'Pendiente',
                                          style: TextStyle(
                                            color:
                                                task.confirmed
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                        if (!task.confirmed)
                                          IconButton.filled(
                                            icon: const Icon(Icons.check),
                                            onPressed: () {
                                              _confirmTask(task.id!);
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
