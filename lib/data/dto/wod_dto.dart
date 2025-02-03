import 'package:cfq/domain/entities/wod_entity.dart';

class WodModel extends WodEntity {
  final String id;
  final List<String> exercises;
  final Map<String, dynamic> level;
  final String description;
  final String? title;

  WodModel({
    required this.id,
    required this.exercises,
    required this.level,
    required this.description,
    this.title,
  }) : super(
          id: id,
          exercises: exercises,
          level: level,
          description: description,
        );

  factory WodModel.fromJson(Map<String, dynamic> json) {
    return WodModel(
      id: json['id'],
      exercises: List<String>.from(json['exercises']),
      level: Map<String, dynamic>.from(json['level']),
      description: json['description'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercises': exercises,
      'level': level,
      'description': description,
      'title': title,
    };
  }

  WodEntity toEntity() {
    return WodEntity(
      id: id,
      exercises: exercises,
      level: level,
      description: description,
    );
  }
}
