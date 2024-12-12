import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_ai/controller_binders.dart';
import 'package:recipe_ai/screens/ui/chat.dart';
import 'package:recipe_ai/screens/ui/splash_screen.dart';

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(410, 900), // Replace with your design size
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.text,
          initialBinding: ControllerBinders(),
          theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
          routes: {
            SplashScreen.text: (context) => const SplashScreen(),
            ChatPage.text: (context) => const ChatPage(),
          },
        );
      },
    );
  }
}
