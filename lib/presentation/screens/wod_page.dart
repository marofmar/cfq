import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cfq/presentation/bloc/wod_cubit.dart';
import 'package:cfq/presentation/bloc/record_cubit.dart';
import 'package:cfq/domain/entities/record_entity.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WOD')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDate,
            calendarFormat: CalendarFormat.week,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
              context.read<WodCubit>().fetchWodBySpecificDate(
                  "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}");
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  items: ['male', 'female']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Gender'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedLevel,
                  items: ['rxd', 'a', 'b', 'c']
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLevel = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Level'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _recordController,
                  decoration: const InputDecoration(labelText: 'Record'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Format the selected date as a string to use as the wodId
                    final wodId =
                        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

                    // Handle the submission of the record
                    final record = RecordEntity(
                      name: _nameController.text,
                      gender: _selectedGender,
                      level: _selectedLevel,
                      wodId: wodId, // Use the formatted date as the wodId
                      record: _recordController.text,
                    );

                    // Call the method to post the record
                    context.read<RecordCubit>().postRecord(record);

                    // Reset the fields after submission
                    _resetFields();
                  },
                  child: const Text('Submit Record'),
                ),
              ],
            ),
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
