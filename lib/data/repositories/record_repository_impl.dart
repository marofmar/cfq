import 'package:cfq/data/datasources/wod_remote_data_source.dart';
import 'package:cfq/domain/entities/record_entity.dart';
import 'package:cfq/domain/repositories/record_repository.dart';

class RecordRepositoryImpl implements RecordRepository {
  final WodRemoteDataSource remoteDataSource;

  RecordRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> postRecord(RecordEntity record) async {
    return await remoteDataSource.postRecord(record);
  }
}
