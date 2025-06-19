part of 'register_otp_verification_screen.dart';

class RegisterOtpVerificationMobileScreen
    extends GetView<RegisterOtpVerificationController> {
  const RegisterOtpVerificationMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
        '',
        backgroundColor: CustomColor.background,
      ),
      body: _bodyWidget(context),
    );
  }

  _bodyWidget(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: Dimensions.defaultHorizontalSize.edgeHorizontal,
        child: Column(
          children: [
            TitleHeader(),
            OtpInputField(
              controller: controller.otpController,
            ),
            Obx(
              () => PrimaryButton(
                title: Strings.submit,
                disable: !controller.isFormValid.value,
                isLoading: controller.isLoading,
                onPressed: () {
                  if (controller.isFormValid.value) {
                    controller.onEmailVerify;
                  }
                },
              ),
            ),
            TimerWidget(
              onResendCode: () {
                controller.onResendOtp;
              },
            ),
          ],
        ),
      ),
    );
  }
}
