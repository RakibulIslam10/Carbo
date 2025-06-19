import 'package:carbo/base/extensions/extensions.dart';
import 'package:carbo/views/auth/register_otp_verification/widget/title_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/themes/token.dart';
import '../../../../base/utils/dimensions.dart';
import '../../../../base/utils/responsive_layout.dart';
import '../../../../base/widgets/custom_app_bar.dart';
import '../../../../base/widgets/otp_input_field.dart';
import '../../../../base/widgets/primary_button.dart';
import '../../../../base/widgets/timer_widget.dart';
import '../../../../languages/strings.dart';
import '../controller/register_otp_verification_controller.dart';
part 'register_otp_verification_tablet_screen.dart';
part 'register_otp_verification_mobile_screen.dart';

class RegisterOtpVerificationScreen extends GetView<RegisterOtpVerificationController> {
  const RegisterOtpVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: RegisterOtpVerificationMobileScreen(),
      tablet: RegisterOtpVerificationTabletScreen(),
    );
  }
}
