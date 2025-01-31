import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data/datasources/wod_remote_data_source.dart';
import 'data/repositories/wod_repository_impl.dart';
import 'data/repositories/record_repository_impl.dart';
import 'domain/repositories/wod_repository.dart';
import 'domain/repositories/record_repository.dart';
import 'domain/usecases/get_wod_by_date.dart';
import 'domain/usecases/get_wod_by_specific_date.dart';
import 'domain/usecases/post_record_by_specific_date.dart';
import 'presentation/bloc/wod_cubit.dart';
import 'presentation/bloc/record_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/verify_phone_number.dart';
import 'domain/usecases/sign_in_with_credential.dart';

final sl = GetIt.instance;

void init() {
  // Cubits
  sl.registerFactory(() => WodCubit(sl(), sl()));
  sl.registerFactory(() => RecordCubit(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetWodByDate(sl()));
  sl.registerLazySingleton(() => GetWodBySpecificDate(sl()));
  sl.registerLazySingleton(() => PostRecordBySpecificDate(sl()));

  // Repositories
  sl.registerLazySingleton<WodRepository>(
    () => WodRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<RecordRepository>(
    () => RecordRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<WodRemoteDataSource>(
    () => WodRemoteDataSourceImpl(FirebaseFirestore.instance),
  );

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerFactory(() => VerifyPhoneNumber(sl()));
  sl.registerFactory(() => SignInWithCredential(sl()));
}
