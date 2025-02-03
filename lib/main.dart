import 'package:cfq/presentation/screens/home_page.dart';
import 'package:cfq/presentation/screens/login_page.dart';
import 'package:cfq/presentation/screens/ranking_page.dart';
import 'package:cfq/presentation/screens/rm_page.dart';
import 'package:cfq/presentation/screens/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cfq/injection_container.dart' as di;
import 'presentation/screens/wod_page.dart';
import 'presentation/bloc/wod_cubit.dart';
import 'presentation/bloc/record_cubit.dart';
import 'firebase_options.dart';
import 'presentation/screens/upload_screen.dart';
import 'package:cfq/presentation/bloc/date_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init(); // GetIt 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WodCubit>(
          create: (_) => di.sl<WodCubit>(),
        ),
        BlocProvider<RecordCubit>(
          create: (_) => di.sl<RecordCubit>(),
        ),
        BlocProvider<DateCubit>(
          create: (_) => DateCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'CrossFit App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
        routes: {
          '/rm': (context) => const RMPage(),
        },
      ),
    );
  }
}
