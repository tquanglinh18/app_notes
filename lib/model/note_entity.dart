const String tableNotes = 'NotesDB';

class NoteEntity {
  final int? id;
  final String title;
  final String createdAt;
  final String lastEdit;
  final String content;

  NoteEntity({
    this.id,
    required this.title,
    required this.createdAt,
    required this.lastEdit,
    required this.content,
  });

  factory NoteEntity.fromMap(Map<String, dynamic> json) => NoteEntity(
        id: json["id"] as int,
        title: json["title"] as String,
        createdAt: json["createdAt"] as String,
        lastEdit: json["lastEdit"] as String,
        content: json["content"] as String,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "createdAt": createdAt,
        "lastEdit": lastEdit,
        "content": content,
      };

  NoteEntity copyWith({
    int? id,
    String? title,
    String? createdAt,
    String? lastEdit,
    String? content,
  }) => NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      lastEdit: lastEdit ?? this.lastEdit,
      content: content ?? this.content,
    );
}
