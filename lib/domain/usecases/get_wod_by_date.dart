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
    try {
      final result = await repository.getWodByDate(DateTime.now());
      if (result.isNotEmpty) {
        return Right(result);
      } else {
        return Left(AppError(message: 'No WODs found.'));
      }
    } catch (e) {
      return Left(AppError(message: 'Error occurred: $e'));
    }
  }
}
