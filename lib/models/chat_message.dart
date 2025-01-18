class ChatMessage {
  String content;
  final bool isUser;
  final DateTime timestamp;
  List<String>? suggestions;
  String? type;
  List<GoalAction>? actions;
  int? actionNum;

  ChatMessage({
    required this.content,
    required this.isUser,
    this.suggestions,
    this.type,
    this.actions,
    this.actionNum,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'content': content,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
    'suggestions': suggestions,
    'type': type,
    'actions': actions?.map((action) => action.toJson()).toList(),
    'action_num': actionNum,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    content: json['answer'] ?? json['content'] ?? '',
    isUser: json['isUser'] ?? false,
    timestamp: DateTime.parse(json['timestamp']),
    suggestions: json['suggestions'] != null 
        ? List<String>.from(json['suggestions'])
        : null,
    type: json['type'],
    actions: json['actions'] != null 
        ? List<GoalAction>.from(json['actions'].map((x) => GoalAction.fromJson(x)))
        : null,
    actionNum: json['action_num'],
  );
}

class GoalAction {
  final String action;
  final GoalData data;

  GoalAction({
    required this.action,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
    'action': action,
    'data': data.toJson(),
  };

  factory GoalAction.fromJson(Map<String, dynamic> json) => GoalAction(
    action: json['action'],
    data: GoalData.fromJson(json['data']),
  );
}

class GoalData {
  final String period;
  final String title;
  final String description;
  final List<String> tags;
  final int priority;
  final DateTime deadline;

  GoalData({
    required this.period,
    required this.title,
    required this.description,
    required this.tags,
    required this.priority,
    required this.deadline,
  });

  Map<String, dynamic> toJson() => {
    'period': period,
    'title': title,
    'description': description,
    'tags': tags,
    'priority': priority,
    'deadline': deadline.toIso8601String(),
  };

  factory GoalData.fromJson(Map<String, dynamic> json) => GoalData(
    period: json['period'],
    title: json['title'],
    description: json['description'],
    tags: List<String>.from(json['tags']),
    priority: json['priority'],
    deadline: DateTime.parse(json['deadline']),
  );
} 