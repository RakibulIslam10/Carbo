part of '../screen/login_screen.dart';

class LogInButtonWidget extends GetView<LoginController> {
  const LogInButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.verticalSize * 0.5),
      child: Obx(
        () => PrimaryButton(
          isLoading: controller.isLoading,
          title: Strings.login,
          disable: !controller.isFormValid.value,
          onPressed: () {
            if (controller.isFormValid.value) {
              controller.onLogInProcess;
            }
          },
        ),
      ),
    );
  }
}
