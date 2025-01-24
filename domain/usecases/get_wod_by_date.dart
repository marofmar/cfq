import 'package:cfq/domain/entities/wod_entity.dart';
import 'package:cfq/domain/repositories/wod_repository.dart';
import 'package:dartz/dartz.dart';

class GetWodByDate {
  final WodRepository repository;

  GetWodByDate(this.repository);

  Future<WodEntity?> call(DateTime date) async {
    return await repository.getWodByDate(date);
  }
}
