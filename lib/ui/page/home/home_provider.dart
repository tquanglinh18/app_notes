import 'package:app_note_sqflite/model/note_entity.dart';
import 'package:flutter/material.dart';

import '../../../database/notes_database.dart';

class HomeProvider with ChangeNotifier {
  bool enableDelete = false;

  bool confirmDelete = false;

  bool isSelectedConfirmDelete = false;

  String keyWord = '';

  List<NoteEntity> listNote = [];

  showDelete() {
    enableDelete = !enableDelete;
    notifyListeners();
  }

  showConfirmDelete() {
    confirmDelete = !confirmDelete;
    notifyListeners();
  }

  saveKeyWord(String key) {
    keyWord = key;
    notifyListeners();
  }

  getListNote() async {
    await NotesDatabase.instance.readAllNotes().then(
      (value) {
        if ((keyWord).isNotEmpty) {
          listNote = value.where((element) => element.title.startsWith(keyWord)).toList();
        } else {
          listNote = value;
        }
      },
    );
    listNote.sort(
      (a, b) {
        return b.lastEditAt.compareTo(a.lastEditAt);
      },
    );
    notifyListeners();
  }

  Future deleteNote(int id) async {
    await NotesDatabase.instance.deleteNote(id);
    notifyListeners();
  }
}
