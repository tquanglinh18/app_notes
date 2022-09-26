import 'package:app_note_sqflite/database/notes_properties.dart';

const String tableNotes = 'NotesDB';

class NoteEntity {
  final int? id;
  final String title;
  final DateTime createdAt;
  final DateTime lastEditAt;
  final String content;

  NoteEntity({
    this.id,
    required this.title,
    required this.createdAt,
    required this.lastEditAt,
    required this.content,
  });

  factory NoteEntity.fromMap(Map<String, dynamic> json) => NoteEntity(
      id: json["id"] as int,
      title: json["title"] as String,
      createdAt: DateTime.parse(json[NotesProperties.createdAt] as String),
      lastEditAt: DateTime.parse(json[NotesProperties.lastEditAt] as String),
      content: json["content"] as String);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "createdAt": createdAt.toIso8601String(),
        "lastEditAt": lastEditAt.toIso8601String(),
        "content": content,
      };

  NoteEntity copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    DateTime? lastEditAt,
    String? content,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      lastEditAt: lastEditAt ?? this.lastEditAt,
      content: content ?? this.content,
    );
  }
}
