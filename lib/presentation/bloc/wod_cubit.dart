import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/wod_entity.dart';
import '../../../domain/usecases/get_wod_by_date.dart';

class WODCubit extends Cubit<WODState> {
  final GetWODByDate getWODByDate;

  WODCubit(this.getWODByDate) : super(WODInitial());

  Future<void> fetchWOD(DateTime date) async {
    emit(WODLoading());
    final wod = await getWODByDate(date);
    if (wod != null) {
      emit(WODLoaded(wod));
    } else {
      emit(WODError('No WOD found for the selected date.'));
    }
  }
}

abstract class WODState {}

class WODInitial extends WODState {}

class WODLoading extends WODState {}

class WODLoaded extends WODState {
  final WOD wod;

  WODLoaded(this.wod);
}

class WODError extends WODState {
  final String message;

  WODError(this.message);
}
