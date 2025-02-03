import 'package:cfq/domain/entities/update_rm_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/domain/usecases/get_current_user.dart';
import 'package:cfq/domain/entities/no_params.dart';
import 'package:cfq/presentation/bloc/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cfq/domain/entities/user_entity.dart';
import 'package:cfq/domain/usecases/update_user_rm.dart';

class UserCubit extends Cubit<UserState> {
  final GetCurrentUser getCurrentUser;
  final UpdateUserRM updateUserRM;

  UserCubit(this.getCurrentUser, this.updateUserRM) : super(const UserState());

  Future<void> loadCurrentUser() async {
    emit(state.copyWith(isLoading: true, error: ''));

    final result = await getCurrentUser(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
      )),
    );
  }

  Future<void> updateRM({
    required LiftType liftType,
    required String rmType,
    required int weight,
  }) async {
    try {
      final user = state.user;
      if (user == null) return;

      final params = UpdateRMParams(
        userId: user.uid,
        liftType: liftType,
        rmType: rmType,
        weight: weight,
      );

      final result = await updateUserRM(params);

      result.fold(
        (failure) => emit(state.copyWith(error: failure.message)),
        (updatedUser) => emit(state.copyWith(user: updatedUser)),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
