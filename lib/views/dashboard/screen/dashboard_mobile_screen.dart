part of 'dashboard_screen.dart';

class DashboardMobileScreen extends GetView<DashboardController> {
  DashboardMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomWidget(
        index: controller.selectedCarIndex.value,
      ),
      extendBody: true,
      drawer: DrawerMobileScreen(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.appBarHeight * 1.3),
        child: TopAppBarWidget(),
      ),
      body: Obx(
        () => controller.isLoading ? Loader() : _bodyWidget(context),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return RefreshIndicator(
      color: CustomColor.primary,
      onRefresh: () async {
        controller.clearData();
        controller.getDashboardInfo();
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          ListView(
            children: [
              SelectTypeBox(),
              TimeDateBox(),
              FindCarButton(),
              CarCarouselSlider(),
            ],
          ),
        ],
      ),
    );
  }
}
