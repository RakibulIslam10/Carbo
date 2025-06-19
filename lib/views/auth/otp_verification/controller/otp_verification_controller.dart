import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../base/api/services/auth_services.dart';

class OtpVerificationController extends GetxController {
  final otpController = TextEditingController();
  RxBool isFormValid = false.obs;

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

  get onResendOtp => onResendOtpProcess();

  get onOtpSubmit => otpVerifyProcess();

  final _isResendLoading = false.obs;

  bool get isResendLoading => _isResendLoading.value;

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  onResendOtpProcess() {
    return AuthServices.resendForgotOtpCode(
      isResendLoading: _isResendLoading,
    );
  }

  otpVerifyProcess() async {
    return AuthServices.otpVerifyProcess(
      code: otpController.text,
      isLoading: _isLoading,
    );
  }
}
