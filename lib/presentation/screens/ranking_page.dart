import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/presentation/bloc/date_cubit.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking')),
      body: Column(
        children: [
          BlocBuilder<DateCubit, DateTime>(
            builder: (context, selectedDate) {
              return TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: selectedDate,
                calendarFormat: CalendarFormat.week,
                selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  context.read<DateCubit>().updateDate(selectedDay);
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<DateCubit, DateTime>(
              builder: (context, selectedDate) {
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('records')
                      .doc(
                          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(
                          child: Text('No records found for this date.'));
                    }

                    final recordsData =
                        snapshot.data!.data() as Map<String, dynamic>;

                    return ListView.builder(
                      itemCount: recordsData.length,
                      itemBuilder: (context, index) {
                        final name = recordsData.keys.elementAt(index);
                        final record =
                            recordsData[name] as Map<String, dynamic>;
                        return ListTile(
                          title: Text(name),
                          subtitle: Text('Score: ${record['record']}'),
                          trailing: Text('Level: ${record['level']}'),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
