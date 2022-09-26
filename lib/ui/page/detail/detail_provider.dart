import 'package:app_note_sqflite/database/notes_database.dart';
import 'package:app_note_sqflite/model/note_entity.dart';
import 'package:flutter/material.dart';

class DetailProvider with ChangeNotifier {
  bool isEnableTextField = false;

  bool isConfirmDelete = false;

  enableTextField() {
    isEnableTextField = !isEnableTextField;
    notifyListeners();
  }

  confirmDelete() {
    isConfirmDelete = !isConfirmDelete;
    notifyListeners();
  }

  updateNote(NoteEntity note) async {
    await NotesDatabase.instance.updateNote(note);
    notifyListeners();
  }

  deleteNote(int id) async {
    await NotesDatabase.instance.deleteNote(id);
    notifyListeners();
  }
}
