import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoListPage extends StatelessWidget {
  final List<Todo> todos;
  final VoidCallback onAdd;
  final Function(int) onToggle;

  const TodoListPage({
    super.key,
    required this.todos,
    required this.onAdd,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todoリスト'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return CheckboxListTile(
            title: Text(todo.title),
            value: todo.isDone,
            onChanged: (_) => onToggle(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
