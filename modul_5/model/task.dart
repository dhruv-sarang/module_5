class Task {
  int? id;
  String name;
  String description;
  String priority;
  String completed;
  int createdAt;

  Task({
    this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.completed,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'priority': priority,
      'completed': completed,
      'createdAt': createdAt
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        priority: map['priority'],
        completed: map['completed'],
        createdAt: map['createdAt']);
  }
}
