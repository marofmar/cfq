import 'package:cfq/domain/entities/ranking_entity.dart';
import 'package:cfq/domain/repositories/ranking_repository.dart';

class GetRankingBySpecificDate {
  final RankingRepository repository;

  GetRankingBySpecificDate(this.repository);

  Future<List<RankingEntity>> call(String date) async {
    return await repository.getRankingByDate(date);
  }
}
