import 'package:cfq/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cfq/presentation/screens/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body: Transform.translate(
        offset: Offset(-40, 0),
        child: Lottie.asset(
          'assets/animations/upq.json',
          fit: BoxFit.cover,
          //alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          //width: MediaQuery.of(context).size.width,
          onLoaded: (composition) {
            Future.delayed(composition.duration, () {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            });
          },
        ),
      ),
    );
  }
}
