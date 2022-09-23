import 'package:app_note_sqflite/database/notes_database.dart';
import 'package:app_note_sqflite/model/note_entity.dart';
import 'package:flutter/material.dart';

class NotesProvider with ChangeNotifier {
  String title = '';

  String content = '';

  bool active = false;

  bool enabledTextFiled = true;

  bool enabledDelete = false;

  bool confirmDelete = false;

  bool enabledEdit = false;

  bool confirmDeleteDetail = false;

  List<NoteEntity> listNote = [];

  bool editText = false;

  checkTitle(String titleInput) {
    title = titleInput;
    notifyListeners();
  }

  checkContent(String contentInput) {
    content = contentInput;
    notifyListeners();
  }

  checkActiveButton(bool activeBtn) {
    active = activeBtn;
    notifyListeners();
  }
  enableDeleteBtn() {
    enabledDelete = !enabledDelete;
    notifyListeners();
  }

  confirmDeleteBtn() {
    confirmDelete = !confirmDelete;
    notifyListeners();
  }

  enableEditText() {
    enabledEdit = !enabledEdit;
    notifyListeners();
  }

  editingText(){
    editText = !editText;
    notifyListeners();
  }

  confirmDeleteDetailPage() {
    confirmDeleteDetail = !confirmDeleteDetail;
    notifyListeners();
  }

  getListNote({String? keyWord}) async {
    await NotesDatabase.instance.readAllNotes().then(
      (value) {
        if((keyWord ?? "").isNotEmpty){
          listNote = value.where((element) => element.title.contains(keyWord ?? '')).toList();
        }
        else{
          listNote = value;
        }

      },
    );
    notifyListeners();
  }

  deleteNote(int id) {
    NotesDatabase.instance.delete(id).then((value) {});
    notifyListeners();
  }

  updateNote(NoteEntity note) async {
    await NotesDatabase.instance.update(note);
    notifyListeners();
  }
}
