import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/authentication/login_page.dart';
import '../providers/auth_provider.dart';
import '../providers/todo_provider.dart';
import 'todo_detail_screen.dart';
import '../models/todo.dart';

const Color navyBlue = Color(0xFF1A237E);
const Color teal = Color(0xFF00ACC1);
const Color lightBg = Color(0xFFE3F2FD);

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    todoProvider.fetchTodos(auth.user!.uid);
  }

  void _showAddTodoSheet(BuildContext context, String uid) {
    titleController.clear();
    detailsController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(
                labelText: "Description",
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_task),
              label: const Text("Add Task"),
              style: ElevatedButton.styleFrom(
                backgroundColor: teal,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Provider.of<TodoProvider>(context, listen: false).addTodo(
                      uid, titleController.text, detailsController.text);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final todoProvider = Provider.of<TodoProvider>(context);
    final uid = auth.user!.uid;

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        title: const Text("My Todos", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [navyBlue, teal]),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                auth.logout().then((_) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: teal,
        onPressed: () => _showAddTodoSheet(context, uid),
        child: const Icon(Icons.add),
      ),
      body: todoProvider.todos.isEmpty
          ? const Center(
              child: Text(
                "No tasks yet 📝",
                style: TextStyle(fontSize: 18, color: navyBlue),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: todoProvider.todos.length,
              itemBuilder: (context, index) {
                final todo = todoProvider.todos[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TodoDetailScreen(todo: todo),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: todo.completed
                            ? [Colors.grey.shade400, Colors.grey.shade200]
                            : [
                                teal.withOpacity(0.8),
                                navyBlue.withOpacity(0.9)
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: todo.completed ? Colors.black54 : Colors.white,
                          decoration: todo.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text(
                        todo.details,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: todo.completed
                                ? Colors.black45
                                : Colors.white70),
                      ),
                      leading: Checkbox(
                        value: todo.completed,
                        activeColor: teal,
                        onChanged: (_) =>
                            todoProvider.toggleComplete(uid, todo),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
                        onPressed: () => todoProvider.deleteTodo(uid, todo.id),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
