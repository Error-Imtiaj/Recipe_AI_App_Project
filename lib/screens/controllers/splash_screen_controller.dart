import 'package:get/get.dart';
import 'package:recipe_ai/screens/ui/chat.dart';

class SplashScreenController extends GetxController {
  final _isNavigated = false.obs;

  Future<void> navigateToSplashScreen() async {
    if (!_isNavigated.value) {
      await Future.delayed(const Duration(seconds: 3));
      _isNavigated.value = true;
      Get.offAllNamed(ChatPage.routename);
    }
  }

  @override
  void onInit() {
    navigateToSplashScreen();
    super.onInit();
  }
}