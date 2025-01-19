

/// 用户数据模型
class UserData {
  final bool isFirstLaunch;
  final DateTime? lastLoginTime;
  final User user;
  final GoalStats stats;

  UserData({
    required this.isFirstLaunch,
    this.lastLoginTime,
    required this.user,
    required this.stats,
  });

  Map<String, dynamic> toJson() => {
    'isFirstLaunch': isFirstLaunch,
    'lastLoginTime': lastLoginTime?.toIso8601String(),
    'user': user.toJson(),
    'stats': stats.toJson(),
  };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    isFirstLaunch: json['isFirstLaunch'] ?? true,
    lastLoginTime: json['lastLoginTime'] != null 
        ? DateTime.parse(json['lastLoginTime'])
        : null,
    user: User.fromJson(json['user']),
    stats: GoalStats.fromJson(json['stats']['goals']),
  );

  UserData copyWith({
    bool? isFirstLaunch,
    DateTime? lastLoginTime,
    User? user,
    GoalStats? stats,
  }) {
    return UserData(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
      user: user ?? this.user,
      stats: stats ?? this.stats,
    );
  }
}

/// 用户信息
class User {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  User({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.lastLoginAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'lastLoginAt': lastLoginAt.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    createdAt: DateTime.parse(json['createdAt']),
    lastLoginAt: DateTime.parse(json['lastLoginAt']),
  );
}

/// 目标统计信息
class GoalStats {
  final int total;
  final int completed;
  final Map<String, PeriodStats> byPeriod;

  GoalStats({
    required this.total,
    required this.completed,
    required this.byPeriod,
  });

  Map<String, dynamic> toJson() => {
    'total': total,
    'completed': completed,
    'byPeriod': byPeriod.map((key, value) => MapEntry(key, value.toJson())),
  };

  factory GoalStats.fromJson(Map<String, dynamic> json) => GoalStats(
    total: json['total'] ?? 0,
    completed: json['completed'] ?? 0,
    byPeriod: (json['byPeriod'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, PeriodStats.fromJson(value)),
    ),
  );
}

/// 周期统计信息
class PeriodStats {
  final int total;
  final int completed;
  final CurrentPeriodStats currentPeriod;

  PeriodStats({
    required this.total,
    required this.completed,
    required this.currentPeriod,
  });

  Map<String, dynamic> toJson() => {
    'total': total,
    'completed': completed,
    'currentPeriod': currentPeriod.toJson(),
  };

  factory PeriodStats.fromJson(Map<String, dynamic> json) => PeriodStats(
    total: json['total'] ?? 0,
    completed: json['completed'] ?? 0,
    currentPeriod: CurrentPeriodStats.fromJson(json['currentPeriod']),
  );
}

/// 当前周期统计信息
class CurrentPeriodStats {
  final int number;
  final int total;
  final int completed;

  CurrentPeriodStats({
    required this.number,
    required this.total,
    required this.completed,
  });

  Map<String, dynamic> toJson() => {
    'number': number,
    'total': total,
    'completed': completed,
  };

  factory CurrentPeriodStats.fromJson(Map<String, dynamic> json) => CurrentPeriodStats(
    number: json['number'] ?? 0,
    total: json['total'] ?? 0,
    completed: json['completed'] ?? 0,
  );
} 