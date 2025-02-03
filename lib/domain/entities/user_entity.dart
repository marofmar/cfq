// 운동 종목을 enum으로 정의
enum LiftType {
  deadlift,
  backSquat,
  frontSquat,
  overheadSquat,
  benchPress,
  cleanAndJerk,
  clean,
  snatch,
  pushPress,
  pushJerk,
}

// 사용자 권한을 enum으로 정의
enum UserRole {
  admin,
  coach,
  member,
  passenger,
}

class UserEntity {
  final String uid;
  final String phoneNumber;
  final UserRole role;
  final String name;
  final List<String> attendedWodIds;
  final List<String> rankedWodIds;
  final Map<LiftType, int> oneRMrecords;
  final Map<LiftType, int> threeRMrecords;
  final Map<LiftType, int> fiveRMrecords;

  const UserEntity({
    required this.uid,
    required this.phoneNumber,
    required this.role,
    required this.name,
    this.attendedWodIds = const [],
    this.rankedWodIds = const [],
    this.oneRMrecords = const {},
    this.threeRMrecords = const {},
    this.fiveRMrecords = const {},
  });

  // String을 enum으로 변환하는 헬퍼 메서드들
  static LiftType stringToLiftType(String str) {
    return LiftType.values.firstWhere(
      (type) => type.toString().split('.').last == str,
      orElse: () => throw ArgumentError('Invalid lift type: $str'),
    );
  }

  static UserRole stringToUserRole(String str) {
    return UserRole.values.firstWhere(
      (role) => role.toString().split('.').last == str,
      orElse: () => throw ArgumentError('Invalid user role: $str'),
    );
  }

  // enum 값을 String으로 변환하는 헬퍼 메서드들
  static String liftTypeToString(LiftType type) {
    return type.toString().split('.').last;
  }

  static String userRoleToString(UserRole role) {
    return role.toString().split('.').last;
  }

  // Map<String, dynamic>으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'role': userRoleToString(role),
      'name': name,
      'attendedWodIds': attendedWodIds,
      'rankedWodIds': rankedWodIds,
      'oneRMrecords': oneRMrecords.map(
        (key, value) => MapEntry(liftTypeToString(key), value),
      ),
      'threeRMrecords': threeRMrecords.map(
        (key, value) => MapEntry(liftTypeToString(key), value),
      ),
      'fiveRMrecords': fiveRMrecords.map(
        (key, value) => MapEntry(liftTypeToString(key), value),
      ),
    };
  }

  // Map<String, dynamic>에서 UserEntity 생성하는 팩토리 메서드
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      uid: json['uid'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: stringToUserRole(json['role'] as String),
      name: json['name'] as String,
      attendedWodIds: List<String>.from(json['attendedWodIds'] ?? []),
      rankedWodIds: List<String>.from(json['rankedWodIds'] ?? []),
      oneRMrecords: (json['oneRMrecords'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(stringToLiftType(key), value as int),
          ) ??
          {},
      threeRMrecords: (json['threeRMrecords'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(stringToLiftType(key), value as int),
          ) ??
          {},
      fiveRMrecords: (json['fiveRMrecords'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(stringToLiftType(key), value as int),
          ) ??
          {},
    );
  }

  // copyWith 메서드
  UserEntity copyWith({
    String? uid,
    String? phoneNumber,
    UserRole? role,
    String? name,
    List<String>? attendedWodIds,
    List<String>? rankedWodIds,
    Map<LiftType, int>? oneRMrecords,
    Map<LiftType, int>? threeRMrecords,
    Map<LiftType, int>? fiveRMrecords,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      name: name ?? this.name,
      attendedWodIds: attendedWodIds ?? this.attendedWodIds,
      rankedWodIds: rankedWodIds ?? this.rankedWodIds,
      oneRMrecords: oneRMrecords ?? this.oneRMrecords,
      threeRMrecords: threeRMrecords ?? this.threeRMrecords,
      fiveRMrecords: fiveRMrecords ?? this.fiveRMrecords,
    );
  }
}
