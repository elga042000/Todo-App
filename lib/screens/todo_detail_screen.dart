import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';

const Color navyBlue = Color(0xFF1A237E);
const Color teal = Color(0xFF00ACC1);
const Color lightBg = Color(0xFFE3F2FD);

class TodoDetailScreen extends StatefulWidget {
  final Todo todo;
  const TodoDetailScreen({required this.todo, super.key});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late TextEditingController titleController;
  late TextEditingController detailsController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    detailsController = TextEditingController(text: widget.todo.details);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    final uid = auth.user!.uid;

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        title: const Text("Todo Details"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [navyBlue, teal]),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final updatedTodo = widget.todo;
              updatedTodo.title = titleController.text;
              updatedTodo.details = detailsController.text;
              todoProvider.updateTodo(uid, updatedTodo);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: "Heading",
                prefixIcon: const Icon(Icons.title, color: teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: detailsController,
              maxLines: 5,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                labelText: "Details",
                prefixIcon: const Icon(Icons.description, color: teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text("Completed: ", style: TextStyle(fontSize: 18)),
                Checkbox(
                  value: widget.todo.completed,
                  activeColor: teal,
                  onChanged: (value) {
                    setState(() {
                      widget.todo.completed = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
