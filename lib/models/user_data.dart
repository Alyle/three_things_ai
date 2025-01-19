class UserData {
  final bool isFirstLaunch;
  final DateTime? lastLoginTime;

  const UserData({
    this.isFirstLaunch = true,
    this.lastLoginTime,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      isFirstLaunch: json['isFirstLaunch'] ?? true,
      lastLoginTime: json['lastLoginTime'] != null 
          ? DateTime.parse(json['lastLoginTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'isFirstLaunch': isFirstLaunch,
    'lastLoginTime': lastLoginTime?.toIso8601String(),
  };

  UserData copyWith({
    bool? isFirstLaunch,
    DateTime? lastLoginTime,
  }) {
    return UserData(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
    );
  }
} 