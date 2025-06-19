import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/api/endpoint/api_endpoint.dart';
import '../../../../base/api/method/request_process.dart';
import '../../../../base/api/services/auth_services.dart';
import '../../auth_model/country_model.dart';

class RegisterController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool agree = false.obs;
  RxString selectedCountry = ''.obs;
  RxString mobileCode = ''.obs;
   List<Country> countryList = [];


  get onRegistration => registrationProcess();
  get onPrivacyPolicy => '';
  RxBool isFormValid = false.obs;

  @override
  void onInit() {
    emailAddressController.addListener(_updateFormValidity);
    passwordController.addListener(_updateFormValidity);
    firstNameController.addListener(_updateFormValidity);
    lastNameController.addListener(_updateFormValidity);
    getAllCountry();
    super.onInit();
  }

  void _updateFormValidity() {
    isFormValid.value = emailAddressController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty;
  }


  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  registrationProcess() async {
    return AuthServices.registrationProcess(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailAddressController.text,
      password: passwordController.text,
      country: selectedCountry.value,
      isLoading: _isLoading,
    );
  }


  late CountryModel _countryModel;
  CountryModel get countryModel => _countryModel;


  final _isCountryLoading = false.obs;
  bool get isCountryLoading => _isCountryLoading.value;

  ///=> Get ALL COUNTY
  Future<CountryModel?> getAllCountry() async {
    return RequestProcess().request<CountryModel>(
      fromJson: CountryModel.fromJson,
      apiEndpoint: ApiEndpoint.getAllCountry,
      isLoading: _isCountryLoading,
      onSuccess: (value) {
        _countryModel = value!;
        _countryModel.data.countries.forEach(
              (element) {
            countryList.add(Country(
              id: element.id,
              name: element.name,
              mobileCode: element.mobileCode,
              currencyName: element.currencyName,
              currencyCode: element.currencyCode,
              currencySymbol: element.currencySymbol,
            ));
          },
        );
      },
    );
  }



}
