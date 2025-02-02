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
  final String uid; // from Auth
  final String phoneNumber; // from Auth
  final String createdAt; // from Auth
  final String lastLoginAt; // from Auth
  final UserRole role; // String 대신 UserRole enum 사용
  final List<String> attendedWodIds; // 참석한 와드 아이디 모음
  final List<String> rankedWodIds; // 랭커였던 와드 아이디 모음
  final Map<LiftType, int> oneRMrecords; // 1RM 기록
  final Map<LiftType, int> threeRMrecords; // 3RM 기록
  final Map<LiftType, int> fiveRMrecords; // 5RM 기록

  UserEntity(
    this.attendedWodIds,
    this.rankedWodIds,
    this.oneRMrecords,
    this.threeRMrecords,
    this.fiveRMrecords, {
    required this.uid,
    required this.phoneNumber,
    required this.createdAt,
    required this.lastLoginAt,
    required this.role,
  });

  // enum 값을 String으로 변환하는 헬퍼 메서드들
  static String liftTypeToString(LiftType type) {
    return type.toString().split('.').last;
  }

  static String userRoleToString(UserRole role) {
    return role.toString().split('.').last;
  }

  // String을 enum으로 변환하는 헬퍼 메서드들
  static LiftType stringToLiftType(String str) {
    return LiftType.values.firstWhere(
      (type) => liftTypeToString(type) == str,
      orElse: () => throw ArgumentError('Invalid lift type: $str'),
    );
  }

  static UserRole stringToUserRole(String str) {
    return UserRole.values.firstWhere(
      (role) => userRoleToString(role) == str,
      orElse: () => throw ArgumentError('Invalid user role: $str'),
    );
  }

  // Firestore에 저장하기 위한 변환 메서드
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'role': userRoleToString(role), // enum을 String으로 변환
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

  // Firestore에서 데이터를 가져올 때 사용하는 팩토리 메서드
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      json['attendedWodIds'].cast<String>(),
      json['rankedWodIds'].cast<String>(),
      (json['oneRMrecords'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(stringToLiftType(key), value as int),
      ),
      (json['threeRMrecords'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(stringToLiftType(key), value as int),
      ),
      (json['fiveRMrecords'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(stringToLiftType(key), value as int),
      ),
      uid: json['uid'],
      phoneNumber: json['phoneNumber'],
      createdAt: json['createdAt'],
      lastLoginAt: json['lastLoginAt'],
      role: stringToUserRole(json['role']), // String을 enum으로 변환
    );
  }
}
