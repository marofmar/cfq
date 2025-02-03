import 'package:cfq/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/presentation/bloc/user_cubit.dart';
import 'package:cfq/presentation/bloc/user_state.dart';
import 'package:cfq/di/get_it.dart';

class RMPage extends StatelessWidget {
  const RMPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserCubit>(
      create: (context) {
        final cubit = sl<UserCubit>();
        cubit.loadCurrentUser();
        return cubit;
      },
      lazy: false,
      child: const RMPageContent(),
    );
  }
}

class RMPageContent extends StatelessWidget {
  const RMPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My RM Page'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '1RM'),
              Tab(text: '3RM'),
              Tab(text: '5RM'),
            ],
          ),
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error.isNotEmpty) {
              return Center(child: Text('Error: ${state.error}'));
            }

            final user = state.user;
            if (user == null) {
              return const Center(child: Text('No user data'));
            }

            return TabBarView(
              children: [
                _buildRMList(context, user.oneRMrecords, '1RM'),
                _buildRMList(context, user.threeRMrecords, '3RM'),
                _buildRMList(context, user.fiveRMrecords, '5RM'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRMList(
      BuildContext context, Map<LiftType, int> records, String rmType) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: LiftType.values.length,
      itemBuilder: (context, index) {
        final liftType = LiftType.values[index];
        final record = records[liftType] ?? 0;

        return Card(
          child: ListTile(
            title: Text(_formatLiftType(liftType)),
            subtitle: Text('$record lb'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () =>
                  _showEditDialog(context, liftType, record, rmType),
            ),
          ),
        );
      },
    );
  }

  String _formatLiftType(LiftType type) {
    // camelCase를 space로 구분된 텍스트로 변환
    final name = type.toString().split('.').last;
    return name
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim();
  }

  void _showEditDialog(BuildContext context, LiftType liftType,
      int currentRecord, String rmType) {
    final controller = TextEditingController(text: currentRecord.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update ${_formatLiftType(liftType)} $rmType'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Weight (lb)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newRecord = int.tryParse(controller.text);
              if (newRecord != null) {
                context.read<UserCubit>().updateRM(
                      liftType: liftType,
                      rmType: rmType,
                      weight: newRecord,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
