import 'package:get/get.dart';
import 'package:recipe_ai/screens/ui/chat.dart';

class SplashScreenController extends GetxController{
   Future<void> navigateToSplashScreen() {
    return Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(ChatPage.text);
    });
  }
}