import 'package:app_note_sqflite/model/note_entity.dart';
import 'package:flutter/material.dart';

import '../../../database/notes_database.dart';

class HomeProvider with ChangeNotifier {
  bool enableDelete = false;

  bool confirmDelete = false;

  bool isSelectedConfirmDelete = false;

  List<NoteEntity> listNote = [];

  showDelete() {
    enableDelete = !enableDelete;
    notifyListeners();
  }

  showConfirmDelete() {
    confirmDelete = !confirmDelete;
    notifyListeners();
  }

  getListNote({String? keyWord}) async {
    await NotesDatabase.instance.readAllNotes().then(
      (value) {
        if ((keyWord ?? "").isNotEmpty) {
          listNote = value.where((element) => element.title.contains(keyWord ?? '')).toList();
        } else {
          listNote = value;
        }
      },
    );
    notifyListeners();
  }

  deleteNote(int id) async {
    await NotesDatabase.instance.delete(id);
    notifyListeners();
  }
}
