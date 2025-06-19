import 'package:get/get.dart';

import '../views/auth/register_otp_verification/controller/register_otp_verification_controller.dart';

class RegisterOtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterOtpVerificationController());
  }
}
