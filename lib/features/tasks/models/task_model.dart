enum TaskCategory { general, clientVisit }

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

class TaskModel {
  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted;
  final TaskCategory category;

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
    TaskCategory? category,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'category': category.value,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      category: TaskCategoryX.fromValue(json['category'] as String?),
    );
  }
}
