import 'package:cfq/domain/usecases/get_ranking_by_specific_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/presentation/bloc/ranking_cubit.dart';
import 'package:cfq/domain/entities/ranking_entity.dart';
import 'package:get_it/get_it.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cfq/presentation/bloc/date_cubit.dart';
import 'package:cfq/presentation/themes/theme_color.dart';

class RankingPage extends StatelessWidget {
  final String date;

  const RankingPage({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 페이지가 생성될 때 현재 DateCubit의 상태를 사용
    final currentDate = context.read<DateCubit>().state;

    return BlocProvider(
      create: (context) => RankingCubit(
        GetIt.I<GetRankingBySpecificDate>(),
      )..fetchRanking(
          "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}"),
      child: Scaffold(
        appBar: AppBar(title: const Text('Ranking')),
        body: Column(
          children: [
            BlocBuilder<DateCubit, DateTime>(
              builder: (context, selectedDate) {
                print('Current focused day in RankingPage: $selectedDate');
                return TableCalendar(
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  focusedDay: selectedDate,
                  calendarFormat: CalendarFormat.week,
                  selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    // DateCubit 상태 업데이트
                    context.read<DateCubit>().updateDate(selectedDay);

                    // 선택된 날짜에 대한 랭킹 데이터 가져오기
                    final formattedDate =
                        "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
                    context.read<RankingCubit>().fetchRanking(formattedDate);
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: AppColor.mint,
                      shape: BoxShape.rectangle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColor.mint,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<RankingCubit, RankingState>(
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
                          leading: Text('${ranking.rank}'),
                          title: Text(ranking.name),
                          subtitle: Text('Record: ${ranking.record}'),
                          trailing: Text('Level: ${ranking.level}'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
