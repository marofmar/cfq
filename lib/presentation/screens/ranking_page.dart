import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/presentation/bloc/ranking_cubit.dart';
import 'package:cfq/domain/entities/ranking_entity.dart';

class RankingPage extends StatelessWidget {
  final String date;

  const RankingPage({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RankingCubit(context.read<GetRankingBySpecificDate>())
            ..fetchRanking(date),
      child: Scaffold(
        appBar: AppBar(title: const Text('Ranking')),
        body: BlocBuilder<RankingCubit, RankingState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error.isNotEmpty) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return ListView.builder(
                itemCount: state.rankings.length,
                itemBuilder: (context, index) {
                  final ranking = state.rankings[index];
                  return ListTile(
                    title: Text('${ranking.rank}. ${ranking.name}'),
                    subtitle: Text('Record: ${ranking.record}'),
                    trailing: Text('Level: ${ranking.level}'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
