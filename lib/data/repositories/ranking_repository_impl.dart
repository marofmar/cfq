import 'package:cfq/data/datasources/ranking_remote_data_source.dart';
import 'package:cfq/domain/entities/ranking_entity.dart';
import 'package:cfq/domain/repositories/ranking_repository.dart';

class RankingRepositoryImpl implements RankingRepository {
  final RankingRemoteDataSource remoteDataSource;

  RankingRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RankingEntity>> getRankingByDate(String date) async {
    final data = await remoteDataSource.getRankingByDate(date);
    return data.map((item) {
      return RankingEntity(
        name: item['name'],
        rank: item['rank'],
        record: item['record'],
        level: item['level'],
        gender: item['gender'],
        wodId: date,
      );
    }).toList();
  }
}
