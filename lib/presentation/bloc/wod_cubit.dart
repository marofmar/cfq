import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/domain/entities/app_error.dart';
import 'package:cfq/domain/entities/no_params.dart';
import 'package:cfq/domain/entities/wod_entity.dart';
import 'package:cfq/domain/usecases/get_wod_by_date.dart';
import 'package:cfq/domain/usecases/get_wod_by_specific_date.dart';
import 'package:dartz/dartz.dart';

class WodCubit extends Cubit<WodState> {
  final GetWodByDate getWodByDate;
  final GetWodBySpecificDate getWodBySpecificDate;

  WodCubit(this.getWodByDate, this.getWodBySpecificDate) : super(WodInitial());

  Future<void> fetchWod(DateTime date) async {
    emit(WodLoading());
    final Either<AppError, List<WodEntity>> result =
        await getWodByDate(NoParams());
    result.fold(
      (error) => emit(WodError(error.message)),
      (wods) {
        if (wods.isNotEmpty) {
          emit(WodLoaded(wods));
        } else {
          emit(WodError('No WODs found.'));
        }
      },
    );
  }

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
