import 'package:cfq/data/datasources/user_remote_data_source.dart';
import 'package:cfq/domain/entities/user_entity.dart';
import 'package:cfq/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:cfq/domain/entities/app_error.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<AppError, UserEntity>> getCurrentUser() async {
    try {
      final userDto = await remoteDataSource.getCurrentUser();
      return Right(userDto.toEntity());
    } catch (e) {
      return Left(AppError(message: e.toString()));
    }
  }
}
