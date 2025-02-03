import 'package:cfq/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final UserEntity? user;
  final bool isLoading;
  final String error;

  const UserState({
    this.user,
    this.isLoading = false,
    this.error = '',
  });

  UserState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, error];
}
