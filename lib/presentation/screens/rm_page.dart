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
    return const RMPageContent();
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
        body: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state.error.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
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

    // 현재 context에서 UserCubit을 가져옴
    final userCubit = context.read<UserCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // dialogContext 사용
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
            onPressed: () => Navigator.pop(dialogContext), // dialogContext 사용
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newRecord = int.tryParse(controller.text);
              if (newRecord != null) {
                print('Attempting to update: $liftType, $rmType, $newRecord');
                // 미리 가져온 userCubit 사용
                userCubit.updateRM(
                  liftType: liftType,
                  rmType: rmType,
                  weight: newRecord,
                );
                print('Update called');
                Navigator.pop(dialogContext); // dialogContext 사용
              } else {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  // dialogContext 사용
                  const SnackBar(content: Text('Please enter a valid number')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
