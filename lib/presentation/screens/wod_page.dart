import 'package:cfq/presentation/bloc/date_cubit.dart';
import 'package:cfq/presentation/bloc/user_state.dart';
import 'package:cfq/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cfq/presentation/bloc/wod_cubit.dart';
import 'package:cfq/presentation/bloc/record_cubit.dart';
import 'package:cfq/domain/entities/record_entity.dart';
import 'package:cfq/presentation/widgets/record_input_form.dart';
import 'package:cfq/presentation/bloc/user_cubit.dart';
import 'package:cfq/domain/entities/user_entity.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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

  @override
  void initState() {
    super.initState();
    // 페이지 로드 시 오늘 날짜의 WOD 불러오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final today = DateTime.now();
      final formattedDate =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      context.read<DateCubit>().updateDate(today);
      context.read<WodCubit>().fetchWodBySpecificDate(formattedDate);
    });
  }

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
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: const Text('WOD'),
        backgroundColor: AppColor.white,
      ),
      body: BlocListener<DateCubit, DateTime>(
        listener: (context, selectedDate) {
          context.read<WodCubit>().fetchWodBySpecificDate(
                "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
              );
        },
        child: Stack(
          children: [
            Column(
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
                        });
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
                  child: BlocBuilder<WodCubit, WodState>(
                    builder: (context, state) {
                      if (state is WodLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is WodLoaded) {
                        if (state.wods.isEmpty &&
                            _selectedDate.weekday == DateTime.sunday) {
                          return Center(
                            child: ElevatedButton(
                              onPressed: () => _generateWod(context),
                              child: const Text('WOD 만들기'),
                            ),
                          );
                        }
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      wod.id,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    if (wod.createdBy != null)
                                      Text(
                                        wod.createdBy!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontStyle: FontStyle.italic,
                                            ),
                                      ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\n${wod.exercises.join('\n\n')}',
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\n${_formatLevels(wod.level)}',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\n${wod.description}',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is WodError) {
                        // 일요일 선택 시 에러 상태에서도 "WOD 만들기" 버튼 표시
                        if (_selectedDate.weekday == DateTime.sunday) {
                          return Center(
                            child: ElevatedButton(
                              onPressed: () => _generateWod(context),
                              child: const Text('WOD 만들기'),
                            ),
                          );
                        }
                        return Center(
                          child: SelectableText.rich(
                            TextSpan(
                              text: state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }
                      return const Center(
                          child: Text('Select a date to view WOD.'));
                    },
                  ),
                ),
              ],
            ),
            BlocBuilder<UserCubit, UserState>(
              builder: (context, userState) {
                final user = userState.user;
                if (user != null &&
                    (user.role == UserRole.admin ||
                        user.role == UserRole.coach)) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.1, // 초기 크기 (10%)
                    minChildSize: 0.1, // 최소 크기
                    maxChildSize: 0.7, // 최대 크기 (70%)
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(40),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              // 드래그 핸들과 제목
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: 40,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const Text(
                                      'WOD 기록 입력',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                              // 기존 RecordInputForm
                              RecordInputForm(
                                nameController: _nameController,
                                recordController: _recordController,
                                selectedGender: _selectedGender,
                                selectedLevel: _selectedLevel,
                                onGenderChanged: (value) {
                                  setState(() {
                                    _selectedGender = value ?? '';
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
                                  context
                                      .read<RecordCubit>()
                                      .postRecord(record);
                                  _resetFields();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
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
      ),
    );
  }

  Future<void> _generateWod(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("사용자가 로그인되어 있지 않습니다.")),
      );
      return;
    }

    // 토큰 갱신 및 재로딩 (필요 시)
    await currentUser.getIdToken(true);
    await currentUser.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;
    final token = await refreshedUser?.getIdToken();
    print("Refreshed ID Token: $token");

    try {
      // 기본 Firebase App 인스턴스를 사용하도록 명시적으로 지정 (필요 시)
      final functions = FirebaseFunctions.instanceFor(app: Firebase.app());
      final callable = functions.httpsCallable('generateWod');
      final result = await callable.call({
        'date':
            "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
      });

      if (result.data['success']) {
        context.read<WodCubit>().fetchWodBySpecificDate(
              "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WOD가 생성되었습니다.')),
        );
      } else {
        throw Exception(result.data['error']);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('WOD 생성 실패: ${e.toString()}')),
      );
    }
  }

  String _formatLevels(Map<String, dynamic> levels) {
    final order = ['rxd', 'a', 'b', 'c'];
    final sortedEntries = levels.entries.toList()
      ..sort((a, b) =>
          order.indexOf(a.key.toLowerCase()) -
          order.indexOf(b.key.toLowerCase()));
    return sortedEntries
        .map((e) => '${e.key.toUpperCase()}: ${e.value}')
        .join('\n');
  }
}
