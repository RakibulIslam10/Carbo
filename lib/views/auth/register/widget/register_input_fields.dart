part of '../screen/register_screen.dart';

class RegisterInputFields extends GetView<RegisterController> {
  const RegisterInputFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PrimaryInputWidget(
                skipEnterText: true,
                label: Strings.firstName,
                controller: controller.firstNameController,
                hintText: Strings.firstName,
              ),
            ),
            Sizes.width.v10,
            Expanded(
              child: PrimaryInputWidget(
                skipEnterText: true,
                label: Strings.lastName,
                controller: controller.lastNameController,
                hintText: Strings.lastName,
              ),
            ),
          ],
        ),
        Sizes.height.v10,
        CountryDropDown(
          label: Strings.Country,
          itemsList: controller.countryList,
          selectMethod: RxString(DynamicLanguage.key(Strings.selectCountry)),
          onChanged: (v) {
            controller.selectedCountry.value = v!.name;
            controller.mobileCode.value = v.mobileCode;
            LocalStorage.save(userCountryCode: v.mobileCode);
            print('--------------------------------');
            print(LocalStorage.userCountryCode);
          },
        ),
        Sizes.height.v10,
        PrimaryInputWidget(
          label: Strings.emailAddress,
          controller: controller.emailAddressController,
          hintText: Strings.emailAddress,
        ),
        Sizes.height.v10,
        PrimaryInputWidget(
          isPasswordField: true,
          label: Strings.password,
          controller: controller.passwordController,
          hintText: Strings.password,
        ),
      ],
    );
  }
}
