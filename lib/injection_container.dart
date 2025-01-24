import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data/datasources/wod_remote_data_source.dart';
import 'data/repositories/wod_repository_impl.dart';
import 'domain/repositories/wod_repository.dart';
import 'domain/usecases/get_wod_by_date.dart';
import 'presentation/bloc/wod_cubit.dart';

final sl = GetIt.instance;

void init() {
  // Cubit
  sl.registerFactory(() => WODCubit(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetWodByDate(sl()));

  // Repository
  sl.registerLazySingleton<WodRepository>(
    () => WODRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<WODRemoteDataSource>(
    () => WODRemoteDataSourceImpl(FirebaseFirestore.instance),
  );
}
