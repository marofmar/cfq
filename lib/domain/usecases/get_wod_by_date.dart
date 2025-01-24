// import '../entities/wod_entity.dart';
// import '../../../domain/repositories/wod_repository.dart';

// class GetWODByDate {
//   final WODRepository repository;

//   GetWODByDate(this.repository);

//   Future<WOD?> call(DateTime date) async {
//     return await repository.getWODByDate(date);
//   }
// }

import 'package:cfq/domain/entities/app_error.dart';
import 'package:cfq/domain/entities/no_params.dart';
import 'package:cfq/domain/entities/wod_entity.dart';
import 'package:cfq/domain/repositories/wod_repository.dart';
import 'package:cfq/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class GetWodByDate extends Usecase<List<WodEntity>, NoParams> {
  final WodRepository repository;

  GetWodByDate(this.repository);

  @override
  Future<Either<AppError, List<WodEntity>>> call(NoParams params) async {
    return await repository.getWodByDate(params.date);
  }
}
