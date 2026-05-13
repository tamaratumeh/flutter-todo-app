class Task {
  final int? id;
  final String title;
  final bool done;
  final DateTime? createdAt;

  Task({
    this.id,
    required this.title,
    this.done = false,
    this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    bool isDone = json['done'] == 1 || json['done'] == true || json['done'] == '1';
    return Task(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      title: json['title'] ?? '',
      done: isDone,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'done': done ? 1 : 0,
    };
  }

  Task copyWith({
    int? id,
    String? title,
    bool? done,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Task => id: $id | title: $title | done: $done';
  }
}