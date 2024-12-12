import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:recipe_ai/screens/controllers/splash_screen_controller.dart';
import 'package:recipe_ai/utils/animation.dart';

class SplashScreen extends StatefulWidget {
  static const String text = '/splashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _splashScreenController = Get.find<SplashScreenController>();

  @override
  void initState() {
    _splashScreenController.navigateToSplashScreen();
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
