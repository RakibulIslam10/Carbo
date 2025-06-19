import 'package:carbo/views/auth/register/controller/register_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../base/themes/token.dart';
import '../../../../base/utils/dimensions.dart';
import '../../../../base/utils/size.dart';
import '../../../../base/widgets/text_widget.dart';
import '../../../../languages/strings.dart';

class TitleHeader extends StatelessWidget {
  TitleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Sizes.height.v40,
        TextWidget(
          fontSize: Dimensions.titleMedium * 1.2,
          textAlign: TextAlign.center,
          padding:
              EdgeInsets.symmetric(vertical: Dimensions.verticalSize * 0.2),
          maxLines: 1,
          Strings.pleaseEnterTheCode,
          fontWeight: FontWeight.bold,
        ),
        FittedBox(
          child: Padding(
            padding: EdgeInsets.only(bottom: Dimensions.verticalSize * 1.5),
            child: Row(
              crossAxisAlignment: crossStart,
              children: [
                TextWidget(
                  padding: EdgeInsets.only(
                    right: Dimensions.horizontalSize * 0.3,
                  ),
                  textAlign: TextAlign.center,
                  color: CustomColor.blackColor.withOpacity(0.5),
                  Strings.weSentADigitCode,
                  fontSize: Dimensions.titleSmall * 1.1,
                  maxLines: 1,
                ),
                TextWidget(
                  padding: EdgeInsets.only(top: 2),
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  color: CustomColor.blackColor.withOpacity(0.5),
                  Get.find<RegisterController>().emailAddressController.text,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.titleSmall * 0.95,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
