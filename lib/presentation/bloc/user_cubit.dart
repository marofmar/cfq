import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/domain/usecases/get_current_user.dart';
import 'package:cfq/domain/entities/no_params.dart';
import 'package:cfq/presentation/bloc/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetCurrentUser getCurrentUser;

  UserCubit(this.getCurrentUser) : super(const UserState());

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
}
