import 'package:carbo/base/utils/local_storage.dart';
import 'package:carbo/views/dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final noteController = TextEditingController();
  final mobileController = TextEditingController();
  final distanceController = TextEditingController();
  final destinationController = TextEditingController();
  RxBool isFormValid = false.obs;
  RxString selectedRoundDate = ''.obs;
  RxString selectedRoundTime = ''.obs;
  var isChecked = false.obs;

  @override
  void onInit() {
    emailController.text = LocalStorage.email;
    mobileController.text = LocalStorage.number;
    emailController.addListener(_updateFormValidity);
    distanceController.addListener(_updateFormValidity);
    destinationController.addListener(_updateFormValidity);
    mobileController.addListener(_updateFormValidity);
    locationController.addListener(_updateFormValidity);
    super.onInit();
  }

  void _updateFormValidity() {
    isFormValid.value = emailController.text.isNotEmpty &&
        distanceController.text.isNotEmpty &&
        destinationController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        mobileController.text.isNotEmpty;
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    emailController.dispose();
    locationController.dispose();
    noteController.dispose();
    mobileController.dispose();
    distanceController.dispose();
    destinationController.dispose();
    super.onClose();
  }

  RxDouble totalFees = 0.0.obs;
  RxDouble totalFeesWithRoundTrip = 0.0.obs;
  RxString Fees = ''.obs;

  void calculateAllCharges() {
    double distance = double.tryParse(distanceController.text) ?? 0;
    double fee =
        double.tryParse(Get.find<DashboardController>().cars.first.fees) ?? 0.0;
    totalFees.value =
        distance * fee * (selectedRoundTime.value.isEmpty ? 1 : 2);

    Fees.value = Get.find<DashboardController>().cars.first.fees;
    totalFeesWithRoundTrip.value = totalFees.value * 2;
  }
}
