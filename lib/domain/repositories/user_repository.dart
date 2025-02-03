import 'package:dartz/dartz.dart';
import 'package:cfq/domain/entities/app_error.dart';
import 'package:cfq/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<AppError, UserEntity>> getCurrentUser();
}
