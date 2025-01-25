import 'package:cfq/data/models/wod_model.dart';
import 'package:cfq/domain/entities/wod_entity.dart';
import '../../../domain/repositories/wod_repository.dart';
import '../datasources/wod_remote_data_source.dart';

class WodRepositoryImpl implements WodRepository {
  final WodRemoteDataSource remoteDataSource;

  WodRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<WodEntity>> getWodByDate(DateTime date) async {
    final wodModels = await remoteDataSource.getWodByDate(date);
    return wodModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<WodEntity> getWodBySpecificDate(String datePath) async {
    final wodModel = await remoteDataSource.getWodBySpecificDate(datePath);
    return wodModel.toEntity();
  }
}
