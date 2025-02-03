import 'package:dartz/dartz.dart';
import 'package:cfq/domain/entities/app_error.dart';
import 'package:cfq/domain/repositories/user_repository.dart';
import 'package:cfq/domain/entities/user_entity.dart';
import 'package:cfq/domain/entities/update_rm_params.dart';

class UpdateUserRM {
  final UserRepository repository;

  UpdateUserRM(this.repository);

  Future<Either<AppError, UserEntity>> call(UpdateRMParams params) async {
    return await repository.updateRM(params);
  }
}
