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
  final UserRole role; // String 대신 UserRole enum 사용
  final String name;
  final List<String> attendedWodIds; // 참석한 와드 아이디 모음
  final List<String> rankedWodIds; // 랭커였던 와드 아이디 모음
  final Map<LiftType, int> oneRMrecords; // 1RM 기록
  final Map<LiftType, int> threeRMrecords; // 3RM 기록
  final Map<LiftType, int> fiveRMrecords; // 5RM 기록

  UserEntity(
    List<String>? attendedWodIds,
    List<String>? rankedWodIds,
    Map<String, int>? oneRMrecords,
    Map<String, int>? threeRMrecords,
    Map<String, int>? fiveRMrecords, {
    required this.uid,
    required this.phoneNumber,
    required this.role,
    required this.name,
  })  : this.attendedWodIds = attendedWodIds ?? [],
        this.rankedWodIds = rankedWodIds ?? [],
        this.oneRMrecords = (oneRMrecords ?? {}).map(
          (key, value) => MapEntry(stringToLiftType(key), value),
        ),
        this.threeRMrecords = (threeRMrecords ?? {}).map(
          (key, value) => MapEntry(stringToLiftType(key), value),
        ),
        this.fiveRMrecords = (fiveRMrecords ?? {}).map(
          (key, value) => MapEntry(stringToLiftType(key), value),
        );

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

  // 비즈니스 로직 메서드들 추가...
}
