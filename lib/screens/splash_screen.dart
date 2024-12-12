import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:recipe_ai/screens/chat.dart';
import 'package:recipe_ai/utils/animation.dart';

class SplashScreen extends StatefulWidget {
  static const String text = '/splashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _navigateToSplashScreen() {
    return Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const ChatPage();
      }));
    });
  }

  @override
  void initState() {
    _navigateToSplashScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            width: 200.w,
            height: 200.h,
            child: LottieBuilder.asset(Animations.splashAnimation)),
      ),
    );
  }
}
