class Task {
  final String? id;
  final String title;
  final String description;
  final String status;
  final String? email;
  final String? createdDate;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    this.email,
    this.createdDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      email: json['email'],
      createdDate: json['createdDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
    };
  }
}

class TaskStatusCount {
  final String status;
  final int count;

  TaskStatusCount({
    required this.status,
    required this.count,
  });

  factory TaskStatusCount.fromJson(Map<String, dynamic> json) {
    return TaskStatusCount(
      status: json['_id'] ?? '',
      count: json['sum'] ?? 0,
    );
  }
}