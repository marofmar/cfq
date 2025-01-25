import 'package:equatable/equatable.dart';

class DateParams extends Equatable {
  final DateTime date;

  DateParams(this.date);

  @override
  List<Object?> get props => [date];
}
