import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/wod_cubit.dart';

class WODPage extends StatelessWidget {
  const WODPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WOD')),
      body: BlocBuilder<WODCubit, WODState>(
        builder: (context, state) {
          if (state is WODLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WODLoaded) {
            return Center(
              child: Text(
                state.wod.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          } else if (state is WODError) {
            return Center(
              child: SelectableText.rich(
                TextSpan(
                  text: state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }
          return const Center(child: Text('Select a date to view WOD.'));
        },
      ),
    );
  }
}
