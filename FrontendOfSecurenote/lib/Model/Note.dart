class Note {
  final int id;
  final String title;
  final String text;

  const Note({required this.id, required this.title, required this.text});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(id: json['id'], title: json['title'], text: json['text']);
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, text: $text}';
  }
}
