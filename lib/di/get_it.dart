// import 'package:get_it/get_it.dart';
// import 'package:http/http.dart';
// import 'package:movie_app/data/core/api_client.dart';
// import 'package:movie_app/data/data_sources/movie_remote_data_source.dart';
// import 'package:movie_app/data/repositories/movie_repository_impl.dart';
// import 'package:movie_app/domain/repositories/movie_repository.dart';
// import 'package:movie_app/domain/usecases/get_playing_now.dart';
// import 'package:movie_app/domain/usecases/get_popular.dart';
// import 'package:movie_app/domain/usecases/get_top_rated.dart';
// import 'package:movie_app/domain/usecases/get_trending.dart';
// import 'package:movie_app/domain/usecases/get_upcoming.dart';

// final getItInstance = GetIt.I;

// Future init() async {
//   // register dependencies
//   getItInstance.registerLazySingleton<Client>(() => Client());

//   getItInstance
//       .registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));

//   getItInstance.registerLazySingleton<MovieRemoteDataSource>(
//       () => MovieRemoteDataSourceImpl(getItInstance()));

//   getItInstance
//       .registerLazySingleton<GetTrending>(() => GetTrending(getItInstance()));
//   getItInstance.registerLazySingleton<GetPlayingNow>(
//       () => GetPlayingNow(getItInstance()));
//   getItInstance
//       .registerLazySingleton<GetPopular>(() => GetPopular(getItInstance()));
//   getItInstance
//       .registerLazySingleton<GetTopRated>(() => GetTopRated(getItInstance()));
//   getItInstance
//       .registerLazySingleton<GetUpcoming>(() => GetUpcoming(getItInstance()));

//   getItInstance.registerLazySingleton<MovieRepository>(
//       () => MovieRepositoryImpl(getItInstance()));
// }
