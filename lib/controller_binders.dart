import 'package:get/get.dart';
import 'package:recipe_ai/screens/controllers/chatpage_controller.dart';
import 'package:recipe_ai/screens/controllers/splash_screen_controller.dart';

class ControllerBinders extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(SplashScreenController());
    Get.put(ChatController());
  }
}
