import 'package:flutter/material.dart';
import '../models/note.dart';
import 'note_detail_page.dart';

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
        tooltip: 'メモを追加',
        child: const Icon(Icons.add),
      ),
    );
  }
}
