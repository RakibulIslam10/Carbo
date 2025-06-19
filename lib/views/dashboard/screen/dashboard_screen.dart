import 'package:cached_network_image/cached_network_image.dart';
import 'package:carbo/assets/assets.dart';
import 'package:carbo/routes/routes.dart';
import 'package:carbo/views/drawer/screen/drawer_screen.dart';
import 'package:carbo/views/update_profile/controller/update_profile_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dynamic_languages/dynamic_languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import '../../../base/api/services/basic_services.dart';
import '../../../base/utils/basic_import.dart';
import '../../../base/widgets/custom_date_picker.dart';
import '../../../base/widgets/custom_time_picker.dart';
import '../controller/dashboard_controller.dart';
import '../model/area_has_type_model.dart';
import '../model/car_area_model.dart';
part 'dashboard_tablet_screen.dart';
part 'dashboard_mobile_screen.dart';
part '../widget/search_bar.dart';
part '../widget/car_carousel_slider.dart';
part '../widget/top_app_bar_widget.dart';
part '../widget/select_type_box.dart';
part '../widget/time_date_box.dart';
part '../widget/bottom_widget.dart';
part '../widget/find_car_button.dart';



class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: DashboardMobileScreen(),
      tablet: DashboardTabletScreen(),
    );
  }
}