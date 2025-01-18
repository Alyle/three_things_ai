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
  DateTime? deadline;  // 新增截止日期
  bool isCompleted;
  final GoalPeriod period;
  List<String> tags;  // 新增标签
  int priority;       // 新增优先级 (1-3)

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.period,
    this.deadline,
    this.isCompleted = false,
    List<String>? tags,
    this.priority = 2,  // 默认中等优先级
  }) : tags = tags ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'deadline': deadline?.toIso8601String(),  // 新增
    'isCompleted': isCompleted,
    'period': period.index,
    'tags': tags,                             // 新增
    'priority': priority,                     // 新增
  };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    createdAt: DateTime.parse(json['createdAt']),
    deadline: json['deadline'] != null 
        ? DateTime.parse(json['deadline']) 
        : null,
    isCompleted: json['isCompleted'],
    period: GoalPeriod.values[json['period'] ?? 0],
    tags: List<String>.from(json['tags'] ?? []),
    priority: json['priority'] ?? 2,
  );

  Goal copyWith({
    String? title,
    String? description,
    GoalPeriod? period,
    DateTime? deadline,
    List<String>? tags,
    int? priority,
    bool? isCompleted,
  }) {
    return Goal(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      period: period ?? this.period,
      deadline: deadline ?? this.deadline,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}

// 优先级常量
class GoalPriority {
  static const int high = 1;
  static const int medium = 2;
  static const int low = 3;

  static String getName(int priority) {
    switch (priority) {
      case high:
        return '高';
      case medium:
        return '中';
      case low:
        return '低';
      default:
        return '中';
    }
  }
} 