class todos {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const todos({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  /*factory todos.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
        'completed': bool completed,
      } =>
        todos(
          userId: userId,
          id: id,
          title: title,
          completed: completed,
        ),
      _ => throw const FormatException('Failed to load todos.'),
    };
  }*/

  factory todos.fromJson(Map<String, dynamic> json) {
    return todos(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }
}
