class Todo {
  String id;
  String title;
  String details;
  bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.details,
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "details": details,
      "completed": completed,
    };
  }

  factory Todo.fromJson(String id, Map data) {
    return Todo(
      id: id,
      title: data["title"],
      details: data["details"] ?? "",
      completed: data["completed"] ?? false,
    );
  }
}
