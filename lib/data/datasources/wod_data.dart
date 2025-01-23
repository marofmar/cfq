class WodData {
  final String date;
  final List<String> wod;

  WodData({required this.date, required this.wod});
}

// sample data
final List<WodData> wodDataList = [
  WodData(date: '2025-01-17', wod: [
    '5 Rounds',
    '40 Double Under',
    '10 Toes to bar',
    '5 Rounds',
    '40 Double Under',
    '15 Strict Press'
  ]),
  WodData(date: '2025-01-18', wod: [
    'A. Build to heavy',
    '5-5-5-5-5 Back Squat',
    'B. Amrap 15\'',
    '10 Muscle Snatch',
    '8 Overhead Lunge',
    '6 Chest to bar',
    '4 Burpess',
    'Rxd 75lb/55lb',
    'Scaled 중량조절, Pull up'
  ]),
  WodData(date: '2025-01-20', wod: [
    'Workout 18.2',
    '1,2,3,4,5,6,7,8,9,10 reps for time of:',
    'Dumbell squats (Double)',
    'Bar-facing burpees',
    'Workout 18.2a',
    '1-rep max clean',
    'Time cap: 12 minutes to complete',
    '18.2 AND 18.2a',
    'Record = time cap/중량',
    'Rxd 22.5kg/15kg',
    'Scaled 15kg/10kg'
  ]),
  WodData(date: '2025-01-21', wod: [
    'A. Build to heavy',
    '10(빈 바벨 웜업)-10-10-10 Back Squat',
    '',
    '마지막 10개 성공중량 기록합니다.'
        'B. 12 Rounds (Team of 2)',
    'I go, U go',
    '21 Double under',
    '3 Push Jerk',
    '3 Muscle up',
    '*3 Band MU or 9 Pull up',
    'Rxd 135lb/95lb',
    'A: 115lb/75lb',
    'B: 95lb/65lb',
    'C: 상담',
  ]),
];
