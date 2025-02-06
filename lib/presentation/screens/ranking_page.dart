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
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateCubit, DateTime>(
      builder: (context, currentDate) {
        return BlocProvider(
          create: (context) => RankingCubit(
            GetIt.I<GetRankingBySpecificDate>(),
          )..fetchRanking(
              "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}",
            ),
          child: BlocListener<DateCubit, DateTime>(
            listener: (context, date) {
              final formattedDate =
                  "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
              context.read<RankingCubit>().fetchRanking(formattedDate);
            },
            child: Scaffold(
              backgroundColor: AppColor.white,
              appBar: AppBar(
                title: const Text('Ranking'),
                backgroundColor: AppColor.white,
              ),
              body: Column(
                children: [
                  BlocBuilder<DateCubit, DateTime>(
                    builder: (context, selectedDate) {
                      return TableCalendar(
                        firstDay: DateTime.utc(2025, 1, 1),
                        lastDay: DateTime.utc(2025, 12, 31),
                        focusedDay: selectedDate,
                        calendarFormat: CalendarFormat.week,
                        selectedDayPredicate: (day) =>
                            isSameDay(selectedDate, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          context.read<DateCubit>().updateDate(selectedDay);
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
                          return const Center(
                              child: CircularProgressIndicator());
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
          ),
        );
      },
    );
  }
}
