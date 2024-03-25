class Note {
  final int noteid;
  final int userid;
  final String title;
  final String text;

  const Note({
    required this.noteid,
    required this.userid,
    required this.title,
    required this.text,
  });

  /*factory todos.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'noteid': int noteid,
        'id': int id,
        'title': String title,
        'text': String text,
      } =>
        todos(
          noteid: noteid,
          id: id,
          title: title,
          text: text,
        ),
      _ => throw const FormatException('Failed to load todos.'),
    };
  }*/

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteid: json['note_id'] as int,
      userid: json['user_id'] as int,
      title: json['title'] as String,
      text: json['text'] as String,
    );
  }
}
