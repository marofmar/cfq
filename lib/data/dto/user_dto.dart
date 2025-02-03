import 'package:cfq/domain/entities/user_entity.dart';

class UserDto {
  final String uid;
  final String phoneNumber;
  final String role;
  final String name; // DTO에서는 String으로 유지
  final List<String>? attendedWodIds;
  final List<String>? rankedWodIds;
  final Map<String, int>? oneRMrecords; // DTO에서는 String 키로 유지
  final Map<String, int>? threeRMrecords;
  final Map<String, int>? fiveRMrecords;

  UserDto({
    required this.uid,
    required this.phoneNumber,
    required this.role,
    this.name = '',
    this.attendedWodIds,
    this.rankedWodIds,
    this.oneRMrecords,
    this.threeRMrecords,
    this.fiveRMrecords,
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
      attendedWodIds,
      rankedWodIds,
      oneRMrecords,
      threeRMrecords,
      fiveRMrecords,
      uid: uid,
      phoneNumber: phoneNumber,
      role: UserEntity.stringToUserRole(role),
      name: name,
    );
  }

  // Entity -> DTO
  factory UserDto.fromEntity(UserEntity entity) {
    return UserDto(
      uid: entity.uid,
      phoneNumber: entity.phoneNumber,
      role: UserEntity.userRoleToString(entity.role),
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
