import 'package:cfq/constants/colors.dart';
import 'package:cfq/data/datasources/wod_data.dart';
import 'package:cfq/logic/repositories/wod_repository.dart';
import 'package:cfq/ui/widgets/calendar_utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WodPage extends StatefulWidget {
  const WodPage({super.key});

  @override
  State<WodPage> createState() => _WodPageState();
}

class _WodPageState extends State<WodPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final WodRepository _wodRepository = WodRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wod Page'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
          Divider(),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<WodData>>(
              future:
                  _wodRepository.getWodByDate(_selectedDay?.toString() ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No WOD found for this date.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final wod = snapshot.data![index];
                      return ListTile(
                        title: Text(wod.date),
                        subtitle: Text(wod.wod.join('\n')),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
