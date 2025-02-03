import 'package:cfq/domain/entities/update_rm_params.dart';
import 'package:cfq/domain/usecases/update_user_rm.dart';
import 'package:dartz/dartz.dart';
import 'package:cfq/domain/entities/app_error.dart';
import 'package:cfq/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<AppError, UserEntity>> getCurrentUser();

  Future<Either<AppError, UserEntity>> updateRM(UpdateRMParams params);
}
