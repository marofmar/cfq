import 'package:cfq/domain/usecases/get_ranking_by_specific_date.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data/datasources/wod_remote_data_source.dart';
import 'data/repositories/wod_repository_impl.dart';
import 'data/repositories/record_repository_impl.dart';
import 'domain/repositories/wod_repository.dart';
import 'domain/repositories/record_repository.dart';
import 'domain/usecases/get_wod_by_specific_date.dart';
import 'domain/usecases/post_record_by_specific_date.dart';
import 'presentation/bloc/wod_cubit.dart';
import 'presentation/bloc/record_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/verify_phone_number.dart';
import 'domain/usecases/sign_in_with_credential.dart';
import 'data/repositories/ranking_repository_impl.dart';
import 'data/datasources/ranking_remote_data_source.dart';
import 'domain/repositories/ranking_repository.dart';
import 'presentation/bloc/ranking_cubit.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'data/datasources/user_remote_data_source.dart';
import 'domain/usecases/get_current_user.dart';
import 'presentation/bloc/user_cubit.dart';
import 'domain/usecases/update_user_rm.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  // Cubits
  sl.registerFactory(() => UserCubit(sl(), sl()));
  sl.registerFactory(() => WodCubit(sl()));
  sl.registerFactory(() => RecordCubit(sl()));
  sl.registerFactory(() => RankingCubit(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => UpdateUserRM(sl()));
  sl.registerLazySingleton(() => GetWodBySpecificDate(sl()));
  sl.registerLazySingleton(() => PostRecordBySpecificDate(sl()));
  sl.registerLazySingleton(() => GetRankingBySpecificDate(sl()));

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<WodRepository>(
    () => WodRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<RecordRepository>(
    () => RecordRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<RankingRepository>(
    () => RankingRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<WodRemoteDataSource>(
    () => WodRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RankingRemoteDataSource>(
    () => RankingRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl(), sl()),
  );

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerFactory(() => VerifyPhoneNumber(sl()));
  sl.registerFactory(() => SignInWithCredential(sl()));
}
