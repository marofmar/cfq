import 'package:cfq/domain/entities/ranking_entity.dart';

abstract class RankingRepository {
  Future<List<RankingEntity>> getRankingByDate(String date);
}
