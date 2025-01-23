import 'package:cfq/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'ui/pages/wod_page.dart';
import 'ui/pages/my_page.dart';
import 'ui/pages/ranking_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const WodPage(),
        ),
        GoRoute(
          path: '/my',
          builder: (context, state) => const MyPage(),
        ),
        GoRoute(
          path: '/ranking',
          builder: (context, state) => const RankingPage(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'CrossFit App',
      theme: ThemeData(
        primaryColor: AppColors.mint,
        scaffoldBackgroundColor: AppColors.white,
      ),
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
    );
  }
}
