import 'package:cfq/presentation/screens/home_page.dart';
import 'package:cfq/presentation/screens/login_page.dart';
import 'package:cfq/presentation/screens/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'injection_container.dart' as di;
import 'presentation/screens/wod_page.dart';
import 'presentation/bloc/wod_cubit.dart';
import 'presentation/bloc/record_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.init(); // Changed setup() to init() which is the conventional name
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
      ],
      child: MaterialApp(
        title: 'CrossFit App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
      ),
    );
  }
}
