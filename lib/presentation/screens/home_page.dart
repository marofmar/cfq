import 'package:cfq/presentation/bloc/date_cubit.dart';
import 'package:cfq/presentation/bloc/record_cubit.dart';
import 'package:cfq/presentation/bloc/wod_cubit.dart';
import 'package:cfq/presentation/screens/my_page.dart';
import 'package:cfq/presentation/screens/rm_page.dart';
import 'package:cfq/presentation/screens/ranking_page.dart';
import 'package:cfq/presentation/screens/wod_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/presentation/bloc/navigation_cubit.dart';
import 'package:cfq/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:cfq/presentation/bloc/ranking_cubit.dart';
import 'package:cfq/presentation/bloc/user_cubit.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DateCubit>(
          create: (_) => DateCubit(),
        ),
        BlocProvider<NavigationCubit>(
          create: (_) => NavigationCubit(),
        ),
        BlocProvider<WodCubit>(
          create: (_) => GetIt.I<WodCubit>(),
        ),
        BlocProvider<RecordCubit>(
          create: (_) => GetIt.I<RecordCubit>(),
        ),
        BlocProvider<RankingCubit>(
          create: (_) => GetIt.I<RankingCubit>(),
        ),
        BlocProvider<UserCubit>(
          create: (_) {
            final cubit = GetIt.I<UserCubit>();
            cubit.loadCurrentUser();
            return cubit;
          },
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) {
            return IndexedStack(
              index: state,
              children: const [
                WodPage(),
                RankingPage(),
                MyPage(),
              ],
            );
          },
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
