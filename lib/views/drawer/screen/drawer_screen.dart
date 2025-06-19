import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_languages/dynamic_languages.dart';
import 'package:flutter/material.dart';
import '../../../base/utils/basic_import.dart';
import '../../../routes/routes.dart';
import '../../auth/login/controller/login_controller.dart';
import '../../auth/register/widget/web_screen.dart';
import '../../dashboard/controller/dashboard_controller.dart';
part 'drawer_tablet_screen.dart';
part 'drawer_mobile_screen.dart';
part '../widget/log_out_popup.dart';
part '../widget/items_list.dart';
part '../widget/profile_image_box.dart';
class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: DrawerMobileScreen(),
      tablet: DrawerTabletScreen(),
    );
  }
}

