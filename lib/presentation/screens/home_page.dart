import 'package:cfq/presentation/bloc/date_cubit.dart';
import 'package:cfq/presentation/screens/my_page.dart';
import 'package:cfq/presentation/screens/ranking_page.dart';
import 'package:cfq/presentation/screens/wod_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cfq/presentation/bloc/navigation_cubit.dart';
import 'package:cfq/presentation/widgets/custom_bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  static const List<Widget> _pages = <Widget>[
    WodPage(),
    RankingPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: Scaffold(
        body: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) {
            return IndexedStack(
              index: state,
              children: _pages,
            );
          },
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
