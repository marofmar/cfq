import 'package:cfq/presentation/bloc/date_cubit.dart';
import 'package:cfq/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cfq/presentation/bloc/wod_cubit.dart';
import 'package:cfq/presentation/bloc/record_cubit.dart';
import 'package:cfq/domain/entities/record_entity.dart';
import 'package:cfq/presentation/screens/ranking_page.dart';
import 'package:cfq/presentation/widgets/record_input_form.dart';

class WodPage extends StatefulWidget {
  const WodPage({Key? key}) : super(key: key);

  @override
  _WodPageState createState() => _WodPageState();
}

class _WodPageState extends State<WodPage> {
  DateTime _selectedDate = DateTime.now();
  final _nameController = TextEditingController();
  final _recordController = TextEditingController();
  String _selectedGender = 'male';
  String _selectedLevel = 'rxd';

  void _resetFields() {
    _nameController.clear();
    _recordController.clear();
    setState(() {
      _selectedGender = 'male';
      _selectedLevel = 'rxd';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _recordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WOD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<DateCubit>(),
                    child: const RankingPage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<DateCubit, DateTime>(
            builder: (context, state) {
              print('Current focused day: $state');
              return TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: state,
                calendarFormat: CalendarFormat.week,
                selectedDayPredicate: (day) => isSameDay(state, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    context.read<DateCubit>().updateDate(selectedDay);
                  });
                  context.read<WodCubit>().fetchWodBySpecificDate(
                      "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}");
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
            child: BlocBuilder<WodCubit, WodState>(
              builder: (context, state) {
                if (state is WodLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WodLoaded) {
                  return ListView.builder(
                    itemCount: state.wods.length,
                    itemBuilder: (context, index) {
                      final wod = state.wods[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID: ${wod.id}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Exercises: ${wod.exercises.join(', ')}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Level: ${wod.level.entries.map((e) => '${e.key}: ${e.value}').join(', ')}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Description: ${wod.description}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is WodError) {
                  return Center(
                    child: SelectableText.rich(
                      TextSpan(
                        text: state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                return const Center(child: Text('Select a date to view WOD.'));
              },
            ),
          ),
          RecordInputForm(
            nameController: _nameController,
            recordController: _recordController,
            selectedGender: _selectedGender,
            selectedLevel: _selectedLevel,
            onGenderChanged: (value) {
              setState(() {
                _selectedGender = value ??
                    ''; // Handle null case by providing empty string default
              });
            },
            onLevelChanged: (value) {
              setState(() {
                _selectedLevel = value ?? '';
              });
            },
            onSubmit: () {
              final wodId =
                  "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

              final record = RecordEntity(
                name: _nameController.text,
                gender: _selectedGender,
                level: _selectedLevel,
                wodId: wodId,
                record: _recordController.text,
              );

              context.read<RecordCubit>().postRecord(record);
              _resetFields();
            },
          ),
          BlocListener<RecordCubit, RecordState>(
            listener: (context, state) {
              if (state is RecordPosted) {
                final message = state.success
                    ? 'Record successfully posted!'
                    : 'Failed to post record.';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              } else if (state is RecordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
            child: Container(), // Placeholder widget
          ),
        ],
      ),
    );
  }
}
