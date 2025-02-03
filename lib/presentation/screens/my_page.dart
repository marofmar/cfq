import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/presentation/bloc/user_cubit.dart';
import 'package:cfq/presentation/bloc/user_state.dart';
import 'package:cfq/di/get_it.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserCubit>(
      create: (context) {
        final cubit = sl<UserCubit>();
        // 즉시 데이터 로드 시작
        cubit.loadCurrentUser();
        return cubit;
      },
      lazy: false, // 즉시 생성
      child: const MyPageContent(),
    );
  }
}

class MyPageContent extends StatelessWidget {
  const MyPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Page'),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(UserState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = state.user;
    if (user == null) {
      return const Center(child: Text('No user data'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${user.name}'),
          Text('Phone: ${user.phoneNumber}'),
          Text('Role: ${user.role.toString().split('.').last}'),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
