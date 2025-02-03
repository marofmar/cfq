import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:cfq/presentation/bloc/user_cubit.dart';
import 'package:cfq/domain/usecases/get_current_user.dart';
import 'package:cfq/data/repositories/user_repository_impl.dart';
import 'package:cfq/data/datasources/user_remote_data_source.dart';
import 'package:cfq/domain/repositories/user_repository.dart';
import 'package:cfq/domain/usecases/update_user_rm.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => UserCubit(sl(), sl()));

  // Use cases
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => UpdateUserRM(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl(), sl()),
  );

  // External
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
