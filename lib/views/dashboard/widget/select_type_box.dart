part of '../screen/dashboard_screen.dart';

class SelectTypeBox extends GetView<DashboardController> {
  const SelectTypeBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimensions.defaultHorizontalSize,
          vertical: Dimensions.verticalSize * 0.5),
      decoration: BoxDecoration(
          color: CustomColor.whiteColor,
          borderRadius: BorderRadius.circular(Dimensions.radius)),
      padding: EdgeInsets.only(
        bottom: Dimensions.verticalSize * 0.5,
        left: Dimensions.defaultHorizontalSize,
        right: Dimensions.defaultHorizontalSize,
      ),
      child: Column(
        children: [
          CustomDropDown<Datum>(
            labelSpacing: Sizes.height.v5,
            label: Strings.selectArea,
            labelFontSize: Dimensions.titleSmall * 0.8,
            hintFontSize: Dimensions.titleSmall * 0.8,
            inputBoxHeight: Dimensions.inputBoxHeight * 0.695,
            fieldPadding: EdgeInsets.symmetric(

              horizontal: Dimensions.horizontalSize * 0.7,
              vertical: Dimensions.verticalSize * 0.37,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius * 1.2),
              color: CustomColor.background,
            ),
            itemsList: controller.areaList,
            selectMethod: RxString(Strings.selectArea),
            onChanged: (v) {
              controller.typeList.clear();
              controller.selectedArea.value = v!;
              controller.areaId.value = v.id;
              controller.areaHasType();
            },
          ),
          Obx(
            () => CustomDropDown<TypesAll>(
              labelSpacing: Sizes.height.v5,
              label: Strings.SelectType,
              labelFontSize: Dimensions.titleSmall * 0.8,
              hintFontSize: Dimensions.titleSmall * 0.8,
              inputBoxHeight: Dimensions.inputBoxHeight * 0.695,
              fieldPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.horizontalSize * 0.7,
                vertical: Dimensions.verticalSize * 0.37,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius * 1.2),
                color: CustomColor.background,
              ),
              itemsList: controller.typeList,
              selectMethod: controller.isLoad
                  ? RxString(Strings.pleaseWait)
                  : RxString(Strings.SelectType),
              onChanged: (v) {
                controller.selectType.value = v!;
                controller.carTypeId.value = v.carTypeId;
                controller.alis.value = v.name;
                print(v.carTypeId);
              },
            ),
          )
        ],
      ),
    );
  }
}
