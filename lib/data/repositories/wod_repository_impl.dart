import '../../domain/entities/wod_entity.dart';
import '../../../domain/repositories/wod_repository.dart';
import '../datasources/wod_remote_data_source.dart';

class WodRepositoryImpl implements WodRepository {
  final WODRemoteDataSource remoteDataSource;

  WodRepositoryImpl(this.remoteDataSource);

  // @override
  // Future<Wod?> getWodByDate(DateTime date) async {
  //   return await remoteDataSource.getWODByDate(date);
  // }

  @override
  Future<WodEntity?> getWodByDate(DateTime date) {
    // TODO: implement getWodByDate
    throw UnimplementedError();
  }
}
