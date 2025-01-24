import 'package:cfq/domain/entities/wod_entity.dart';

class WodModel extends WodEntity {
  final String id;
  final List<String> exercises;
  final Map<String, dynamic> level;
  final String description;

  WodModel({
    required this.id,
    required this.exercises,
    required this.level,
    required this.description,
  }) : super(
          id: id,
          exercises: exercises,
          level: level,
          description: description,
        );

  factory WodModel.fromJson(Map<String, dynamic> json) {
    return WodModel(
      id: json['id'],
      exercises: json['exercises'],
      level: json['level'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercises': exercises,
      'level': level,
      'description': description,
    };
  }
}
