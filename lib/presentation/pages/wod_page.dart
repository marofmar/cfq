import 'package:cfq/data/datasources/wod_data.dart';
import 'package:cfq/domain/repositories/wod_repository.dart';
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
  DateTime? _selectedDay; // selected는

  final WodRepository _wodRepository = WodRepository();

  @override
  Widget build(BuildContext context) {
    final Future<List<WodData>> wodData =
        _wodRepository.getWodByDate(_selectedDay?.toString() ?? '');
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Workout of the Day'),
                  FutureBuilder<List<WodData>>(
                    future: wodData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            for (var wod in snapshot.data!)
                              Text(wod.wod.join('\n')),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
