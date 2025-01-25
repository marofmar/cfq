import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/domain/entities/app_error.dart';
import 'package:cfq/domain/entities/record_entity.dart';
import 'package:cfq/domain/usecases/post_record_by_specific_date.dart';
import 'package:dartz/dartz.dart';

class RecordCubit extends Cubit<RecordState> {
  final PostRecordBySpecificDate postRecordBySpecificDate;

  RecordCubit(this.postRecordBySpecificDate) : super(RecordInitial());

  Future<void> postRecord(RecordEntity record) async {
    emit(RecordLoading());
    final Either<AppError, bool> result =
        await postRecordBySpecificDate(record);
    result.fold(
      (error) => emit(RecordError(error.message)),
      (success) => emit(RecordPosted(success)),
    );
  }
}

abstract class RecordState {}

class RecordInitial extends RecordState {}

class RecordLoading extends RecordState {}

class RecordPosted extends RecordState {
  final bool success;

  RecordPosted(this.success);
}

class RecordError extends RecordState {
  final String message;

  RecordError(this.message);
}
