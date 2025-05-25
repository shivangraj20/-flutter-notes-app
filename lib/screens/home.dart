import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> notes = [];
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async{
    final prefs = await SharedPreferences.getInstance();
    final String? notesData = prefs.getString('notes');

    if(notesData != null){
      setState(() {
        notes.clear();
        notes.addAll(List<String>.from(jsonDecode(notesData)));
      });
    }

  }

  Future<void> _saveNotes() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('notes', jsonEncode(notes));
  }

  void _addNote() {
    String text = _noteController.text.trim();
    if(text.isNotEmpty){
      setState(() {
        notes.add(text);
      });
      _noteController.clear();
    }
  }
  void _deleteNote(int index){
    setState(() {
      notes.removeAt(index);
    });
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                  hintText: 'Enter a note',
                  border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    title: Text(notes[index]),
                    )
                  )
                )
            )
          ],
        ),
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(
          Icons.add,
        )
      )
    );
  }
}
