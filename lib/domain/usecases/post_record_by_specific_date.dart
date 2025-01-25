import 'package:cfq/domain/entities/app_error.dart';
import 'package:cfq/domain/entities/record_entity.dart';
import 'package:cfq/domain/repositories/record_repository.dart';
import 'package:cfq/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class PostRecordBySpecificDate extends Usecase<bool, RecordEntity> {
  final RecordRepository repository;

  PostRecordBySpecificDate(this.repository);

  @override
  Future<Either<AppError, bool>> call(RecordEntity record) async {
    try {
      final result = await repository.postRecord(record);
      return Right(result);
    } catch (e) {
      return Left(AppError(message: 'Error posting record: $e'));
    }
  }
}
