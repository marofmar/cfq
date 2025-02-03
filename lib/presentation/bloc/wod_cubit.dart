import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/domain/entities/app_error.dart';
import 'package:cfq/domain/entities/wod_entity.dart';
import 'package:cfq/domain/usecases/get_wod_by_specific_date.dart';
import 'package:dartz/dartz.dart';

class WodCubit extends Cubit<WodState> {
  final GetWodBySpecificDate getWodBySpecificDate;

  WodCubit(this.getWodBySpecificDate) : super(WodInitial());

  Future<void> fetchWodBySpecificDate(String datePath) async {
    emit(WodLoading());
    final Either<AppError, WodEntity> result =
        await getWodBySpecificDate(datePath);
    result.fold(
      (error) => emit(WodError(error.message)),
      (wod) => emit(WodLoaded([wod])),
    );
  }
}

abstract class WodState {}

class WodInitial extends WodState {}

class WodLoading extends WodState {}

class WodLoaded extends WodState {
  final List<WodEntity> wods;

  WodLoaded(this.wods);
}

class WodError extends WodState {
  final String message;

  WodError(this.message);
}
