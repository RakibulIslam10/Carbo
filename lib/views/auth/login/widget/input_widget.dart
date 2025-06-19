part of '../screen/login_screen.dart';

class InputWidget extends GetView<LoginController> {
  const InputWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryInputWidget(
          controller: controller.emailAddressController,
          label: Strings.emailAddress,
          hintText: Strings.emailAddress,
          textInputType: TextInputType.emailAddress,
          showBorderSide: true,
        ),
        Sizes.height.betweenInputBox,
        PrimaryInputWidget(
          controller: controller.passwordController,
          label: Strings.password,
          hintText: Strings.password,
          isPasswordField: true,
          textInputType: TextInputType.text,
        ),
        _isRememberMeWidget(context),
        Sizes.height.v30,
      ],
    );
  }

  _isRememberMeWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.heightSize * 0.66),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => Get.toNamed(Routes.reset_passwordScreen),
            child: TextWidget(
              Strings.forgotPassword,
              fontWeight: FontWeight.w400,
              color: CustomColor.primary,
              typographyStyle: TypographyStyle.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
