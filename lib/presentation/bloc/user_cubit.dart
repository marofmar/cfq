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
      print('UserCubit updateRM called');
      final user = state.user;
      if (user == null) {
        print('No user found in state');
        return;
      }

      final params = UpdateRMParams(
        userId: user.uid,
        liftType: liftType,
        rmType: rmType,
        weight: weight,
      );

      final result = await updateUserRM(params);
      print('Update result received');

      result.fold(
        (failure) {
          print('Update failed: ${failure.message}');
          emit(state.copyWith(error: failure.message));
        },
        (updatedUser) {
          print('Update successful');
          emit(state.copyWith(user: updatedUser));
        },
      );
    } catch (e) {
      print('Error in updateRM: $e');
      emit(state.copyWith(error: e.toString()));
    }
  }
}
