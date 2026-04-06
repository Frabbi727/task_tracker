enum TaskCategory { general, clientVisit }

enum TaskPriority { low, medium, high }

extension TaskCategoryX on TaskCategory {
  String get value {
    switch (this) {
      case TaskCategory.general:
        return 'general';
      case TaskCategory.clientVisit:
        return 'clientVisit';
    }
  }

  String get label {
    switch (this) {
      case TaskCategory.general:
        return 'General';
      case TaskCategory.clientVisit:
        return 'Client Visit';
    }
  }

  static TaskCategory fromValue(String? value) {
    return TaskCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => TaskCategory.general,
    );
  }
}

extension TaskPriorityX on TaskPriority {
  String get value {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  static TaskPriority fromValue(String? value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => TaskPriority.medium,
    );
  }
}

class TaskModel {
  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.status,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String priority;
  final String status;
  final TaskCategory category;

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? priority,
    String? status,
    TaskCategory? category,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'priority': priority,
      'status': status,
      'category': category.value,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final storedStatus = json['status'] as String?;
    final legacyCompleted = json['isCompleted'] as bool?;

    return TaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      priority: json['priority'] as String? ?? TaskPriority.medium.value,
      status:
          storedStatus ??
          ((legacyCompleted ?? false) ? 'COMPLETED' : 'PENDING'),
      category: TaskCategoryX.fromValue(json['category'] as String?),
    );
  }
}
