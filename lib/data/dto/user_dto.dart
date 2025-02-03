import 'package:cfq/domain/entities/user_entity.dart';

class UserDto {
  final String uid;
  final String phoneNumber;
  final String role;
  final String name;
  final List<String> attendedWodIds;
  final List<String> rankedWodIds;
  final Map<String, int> oneRMrecords;
  final Map<String, int> threeRMrecords;
  final Map<String, int> fiveRMrecords;

  const UserDto({
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

  // JSON -> DTO
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      uid: json['uid'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String,
      name: json['name'] as String,
      attendedWodIds: List<String>.from(json['attendedWodIds'] ?? []),
      rankedWodIds: List<String>.from(json['rankedWodIds'] ?? []),
      oneRMrecords: Map<String, int>.from(json['oneRMrecords'] ?? {}),
      threeRMrecords: Map<String, int>.from(json['threeRMrecords'] ?? {}),
      fiveRMrecords: Map<String, int>.from(json['fiveRMrecords'] ?? {}),
    );
  }

  // DTO -> JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'role': role,
      'name': name,
      'attendedWodIds': attendedWodIds,
      'rankedWodIds': rankedWodIds,
      'oneRMrecords': oneRMrecords,
      'threeRMrecords': threeRMrecords,
      'fiveRMrecords': fiveRMrecords,
    };
  }

  // DTO -> Entity
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      phoneNumber: phoneNumber,
      role: UserEntity.stringToUserRole(role),
      name: name,
      attendedWodIds: attendedWodIds,
      rankedWodIds: rankedWodIds,
      oneRMrecords: oneRMrecords.map(
        (key, value) => MapEntry(UserEntity.stringToLiftType(key), value),
      ),
      threeRMrecords: threeRMrecords.map(
        (key, value) => MapEntry(UserEntity.stringToLiftType(key), value),
      ),
      fiveRMrecords: fiveRMrecords.map(
        (key, value) => MapEntry(UserEntity.stringToLiftType(key), value),
      ),
    );
  }

  // Entity -> DTO
  factory UserDto.fromEntity(UserEntity entity) {
    return UserDto(
      uid: entity.uid,
      phoneNumber: entity.phoneNumber,
      role: UserEntity.userRoleToString(entity.role),
      name: entity.name,
      attendedWodIds: entity.attendedWodIds,
      rankedWodIds: entity.rankedWodIds,
      oneRMrecords: entity.oneRMrecords.map(
        (key, value) => MapEntry(UserEntity.liftTypeToString(key), value),
      ),
      threeRMrecords: entity.threeRMrecords.map(
        (key, value) => MapEntry(UserEntity.liftTypeToString(key), value),
      ),
      fiveRMrecords: entity.fiveRMrecords.map(
        (key, value) => MapEntry(UserEntity.liftTypeToString(key), value),
      ),
    );
  }
}
