class WodEntity {
  final String id; // 2025-01-23
  final List<String> exercises;
  final Map<String, dynamic> level;
  final String? title;

  final String description; // 기타 설명 nullable, youtube 동작 링크라던지

  WodEntity({
    required this.id,
    required this.exercises,
    required this.level,
    required this.description,
    this.title,
  });

  @override
  List<Object?> get props =>
      [id]; // id will be used to determine equality (Equatable)

  @override
  bool? get stringify => true;
}
