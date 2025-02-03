import 'package:cfq/domain/entities/user_entity.dart';
import 'package:cfq/domain/repositories/user_repository.dart';
import 'package:cfq/domain/entities/no_params.dart';
import 'package:dartz/dartz.dart';
import 'package:cfq/domain/entities/app_error.dart';

class GetCurrentUser {
  final UserRepository repository;

  GetCurrentUser(this.repository);

  Future<Either<AppError, UserEntity>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
