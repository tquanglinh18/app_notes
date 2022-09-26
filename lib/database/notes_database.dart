import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/note_entity.dart';
import 'notes_properties.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const titleType = 'TEXT NOT NULL';
    const createdAtType = 'TEXT NOT NULL';
    const lastEditType = 'TEXT NOT NULL';
    const contentType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${NotesProperties.id} $idType, 
  ${NotesProperties.title} $titleType,
  ${NotesProperties.createdAt} $createdAtType,
  ${NotesProperties.lastEditAt} $lastEditType,
  ${NotesProperties.content} $contentType
  )
''');
  }

  Future<NoteEntity> create(NoteEntity note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toMap());
    return note.copyWith(id: id);
  }

  Future<List<NoteEntity>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query(tableNotes);
    return result.map((json) => NoteEntity.fromMap(json)).toList();
  }

  Future<int> updateNote(NoteEntity note) async {
    final db = await instance.database;
    return db.update(
      tableNotes,
      note.toMap(),
      where: '${NotesProperties.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableNotes,
      where: '${NotesProperties.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
