import 'package:get/get.dart';

import '../../../base/utils/navigator_plug.dart';
import '../../../routes/routes.dart';

class SplashController extends GetxController {
  final navigatorPlug = NavigatorPlug();

  @override
  void onReady() {
    super.onReady();
    navigatorPlug.startListening(
      seconds: 3,
      onChanged: () {
       Get.offAndToNamed(Routes.onboardScreen);
      },
    );
  }

  @override
  void onClose() {
    navigatorPlug.stopListening();
    super.onClose();
  }
}
