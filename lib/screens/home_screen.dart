import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/todo.dart';
import 'add_note_page.dart';
import 'add_todo_page.dart';
import 'counter_page.dart';
import 'notes_list_page.dart';
import 'todo_list_page.dart';
import 'calculator_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Note> _notes = [];
  final List<Todo> _todos = [];

  void _addNewNote() async {
    final note = await Navigator.of(context).push<Note>(
      MaterialPageRoute(builder: (_) => const AddNotePage()),
    );
    if (note != null) {
      setState(() {
        _notes.add(note);
        _notes.sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }

  void _addNewTodo() async {
    final todo = await Navigator.of(context).push<Todo>(
      MaterialPageRoute(builder: (_) => const AddTodoPage()),
    );
    if (todo != null) {
      setState(() {
        _todos.add(todo);
      });
    }
  }

  void _toggleTodoDone(int index) {
    setState(() {
      final todo = _todos[index];
      todo.isDone = !todo.isDone;
      if (todo.isDone) {
        _todos.removeAt(index);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const CounterPage(),
          NotesListPage(notes: _notes, onAdd: _addNewNote),
          TodoListPage(
            todos: _todos,
            onAdd: _addNewTodo,
            onToggle: _toggleTodoDone,
          ),
          const CalculatorPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF00008B),
        unselectedItemColor: const Color(0xFF00008B),
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.countertops),
            label: 'カウンター',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'メモ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: '電卓',
          ),
        ],
      ),
    );
  }
}
