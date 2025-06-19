import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../base/api/services/auth_services.dart';

class RegisterOtpVerificationController extends GetxController {
  final otpController = TextEditingController();

  RxBool isFormValid = false.obs;

  // Routing
  get onEmailVerify => emailVerifyProcess();
  get onResendOtp => onResendOtpProcess();
  void _updateFormValidity() {
    isFormValid.value = otpController.text.length == 6;
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    otpController.addListener(_updateFormValidity);
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isResendLoading = false.obs;
  bool get isResendLoading => _isResendLoading.value;

  emailVerifyProcess() async {
    return AuthServices.emailVerifyProcess(
      code: otpController.text,
      isLoading: _isLoading,
    );
  }

  onResendOtpProcess() {
    return AuthServices.resendEmailOtpCode(
      isResendLoading: _isResendLoading,
    );
  }

}
