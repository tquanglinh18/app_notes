import 'package:app_note_sqflite/model/note_entity.dart';
import 'package:flutter/material.dart';

import '../../../database/notes_database.dart';

class CreateNoteViewModel with ChangeNotifier {
  String title = '';
  String content = '';
  bool isActive = false;

  onChangedTitle(String titleInput) {
    title = titleInput;
    notifyListeners();
  }

  onChangedContent(String contentInput) {
    content = contentInput;
    notifyListeners();
  }

  Future createNote(NoteEntity note) async {
    await NotesDatabase.instance.createNote(note);
    notifyListeners();
  }

}
