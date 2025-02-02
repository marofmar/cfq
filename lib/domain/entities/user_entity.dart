class UserEntity {
  final String uid; // from Auth
  final String phoneNumber; // from Auth
  final String createdAt; // from Auth
  final String lastLoginAt; // from Auth
  final String role; // 권한 { admin, coach, member, passenger }
  final List<String> attendedWodIds; // 참석한 와드 아이디 모음
  final List<String> rankedWodIds; // 랭커였던 와드 아이디 모음
  final Map<String, dynamic> oneRMrecords; // 1RM 기록
  final Map<String, dynamic> threeRMrecords; // 3RM 기록
  final Map<String, dynamic> fiveRMrecords; // 5RM 기록

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
}
