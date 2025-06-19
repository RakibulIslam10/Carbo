import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../utils/basic_import.dart';

class OtpInputField extends StatelessWidget {
  const OtpInputField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      controller: controller,
      appContext: context,
      cursorColor: CustomColor.typographyShade.full,
      length: 6,
      obscureText: false,
      keyboardType: TextInputType.number,
      textStyle: TextStyle(color: CustomColor.typographyShade.full),
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(
          Dimensions.radius * 0.8,
        ),
        selectedColor: CustomColor.typographyShade.full,
        activeColor: CustomColor.typographyShade.full,
        inactiveColor: CustomColor.typographyShade.zero,
        // fieldHeight: Dimensions.inputBoxHeight,
        fieldWidth: Dimensions.verticalSize * 1.8,
        activeFillColor: CustomColor.typographyShade.zero,
        borderWidth: 0.5,
        activeBorderWidth: 0.5,
      ),
      onChanged: (String value) {},
    );
  }
}
