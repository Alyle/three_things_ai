enum GoalPeriod {
  daily,    // 每天
  weekly,   // 每周
  monthly,  // 每月
  quarterly,// 每季度
  yearly    // 每年
}

class Goal {
  final String id;
  String title;
  String description;
  final DateTime createdAt;
  bool isCompleted;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'isCompleted': isCompleted,
  };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    createdAt: DateTime.parse(json['createdAt']),
    isCompleted: json['isCompleted'],
  );
} 