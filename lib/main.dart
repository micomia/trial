import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Note {
  final String title;
  final String body;
  final DateTime date;

  Note({required this.title, required this.body, required this.date});
}

class Todo {
  final String title;
  bool isDone;

  Todo({required this.title, this.isDone = false});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}

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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.countertops),
            label: 'カウンター',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'ノート',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Todo',
          ),
        ],
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Text(
                '$_counter',
                key: ValueKey<int>(_counter),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NotesListPage extends StatelessWidget {
  final List<Note> notes;
  final VoidCallback onAdd;

  const NotesListPage({super.key, required this.notes, required this.onAdd});

  String _formatDate(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${date.year}/${twoDigits(date.month)}/${twoDigits(date.day)} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモ一覧'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(_formatDate(note.date)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NoteDetailPage(note: note),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoListPage extends StatelessWidget {
  final List<Todo> todos;
  final VoidCallback onAdd;
  final Function(int) onToggle;

  const TodoListPage(
      {super.key,
      required this.todos,
      required this.onAdd,
      required this.onToggle});

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
        tooltip: 'やることを追加',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteDetailPage extends StatelessWidget {
  final Note note;

  const NoteDetailPage({super.key, required this.note});

  String _formatDate(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${date.year}/${twoDigits(date.month)}/${twoDigits(date.day)} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモ詳細'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              _formatDate(note.date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(note.body),
          ],
        ),
      ),
    );
  }
}

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _save() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    final note = Note(title: title, body: content, date: DateTime.now());
    Navigator.of(context).pop(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規メモ'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'タイトル'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: '内容'),
              maxLines: 8,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: const Text('保存')),
          ],
        ),
      ),
    );
  }
}

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _controller = TextEditingController();

  void _save() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    final todo = Todo(title: text);
    Navigator.of(context).pop(todo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規Todo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Todo'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: const Text('保存')),
          ],
        ),
      ),
    );
  }
}

