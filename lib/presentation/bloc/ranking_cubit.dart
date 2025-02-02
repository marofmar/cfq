import 'package:bloc/bloc.dart';
import 'package:cfq/domain/entities/ranking_entity.dart';
import 'package:cfq/domain/usecases/get_ranking_by_specific_date.dart';

class RankingState {
  final List<RankingEntity> rankings;
  final bool isLoading;
  final String error;

  RankingState({
    this.rankings = const [],
    this.isLoading = false,
    this.error = '',
  });
}

class RankingCubit extends Cubit<RankingState> {
  final GetRankingBySpecificDate getRankingBySpecificDate;

  RankingCubit(this.getRankingBySpecificDate) : super(RankingState());

  Future<void> fetchRanking(String date) async {
    emit(RankingState(isLoading: true));
    try {
      final rankings = await getRankingBySpecificDate(date);
      rankings.sort((a, b) => a.rank.compareTo(b.rank));
      emit(RankingState(rankings: rankings));
    } catch (e) {
      emit(RankingState(error: e.toString()));
    }
  }
}
