import 'package:cfq/domain/entities/app_error.dart';
import 'package:cfq/domain/entities/wod_entity.dart';
import 'package:cfq/domain/repositories/wod_repository.dart';
import 'package:cfq/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class GetWodBySpecificDate extends Usecase<WodEntity, String> {
  final WodRepository repository;

  GetWodBySpecificDate(this.repository);

  @override
  Future<Either<AppError, WodEntity>> call(String datePath) async {
    try {
      final wodEntity = await repository.getWodBySpecificDate(datePath);
      return Right(wodEntity);
    } catch (e) {
      print(e);
      return Left(AppError(message: 'WOD 없어요. 좀 쉬세요!'));
    }
  }
}
