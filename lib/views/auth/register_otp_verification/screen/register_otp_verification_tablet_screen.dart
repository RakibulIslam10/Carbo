part of 'register_otp_verification_screen.dart';

class RegisterOtpVerificationTabletScreen extends GetView<RegisterOtpVerificationController> {
  const RegisterOtpVerificationTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar('RegisterOtpVerification Tablet Screen'),
      body: _bodyWidget(context),
    );
  }

  _bodyWidget(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [],
      ),
    );
  }
}
