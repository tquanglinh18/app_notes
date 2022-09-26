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

  getNote(int id) async {
    await NotesDatabase.instance.readNote(id);
    notifyListeners();
  }

  Future updateNote(NoteEntity note) async {
    await NotesDatabase.instance.updateNote(note);
    notifyListeners();
  }

  Future deleteNote(int id) async {
    await NotesDatabase.instance.deleteNote(id);
    notifyListeners();
  }
}
