import 'package:carbo/base/utils/local_storage.dart';
import 'package:carbo/views/booking/controller/booking_controller.dart';
import 'package:carbo/views/dashboard/controller/dashboard_controller.dart';
import 'package:carbo/views/preview/model/booking_preview_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../base/api/endpoint/api_endpoint.dart';
import '../../../base/api/method/request_process.dart';
import '../../../base/api/model/common_success_model.dart';
import '../../../languages/strings.dart';
import '../../../routes/routes.dart';
import '../../congratulations/model/congratulations_model.dart';
import '../../congratulations/screen/congratulations_screen.dart';
import '../model/booking_confirm_model.dart';
import '../model/manual_input_model.dart';
import '../screen/preview_screen.dart';
import '../widget/web_payment_screen.dart';

class PreviewController extends GetxController {
  final dashboardController = Get.put(DashboardController());

  List<TextEditingController> inputFieldControllers = [];
  RxList inputFields = [].obs;
  RxList inputFileFields = [].obs;
  RxBool hasFile = false.obs;
  RxString selectType = "".obs;
  List<String> listImagePath = [];
  List<String> listFieldName = [];

  updateImageData(String fieldName, String imagePath) {
    if (listFieldName.contains(fieldName)) {
      int itemIndex = listFieldName.indexOf(fieldName);
      listImagePath[itemIndex] = imagePath;
    } else {
      listFieldName.add(fieldName);
      listImagePath.add(imagePath);
    }
    update();
  }

  String? getImagePath(String fieldName) {
    if (listFieldName.contains(fieldName)) {
      int itemIndex = listFieldName.indexOf(fieldName);
      return listImagePath[itemIndex];
    }
    return null;
  }

  Rxn<PaymentGateway> selectPaymentGateway = Rxn<PaymentGateway>();
  final List<PaymentGateway> paymentGatewayList = [];
  Rxn<Currency> selectedCurrency = Rxn<Currency>();
  final List<Currency> currencyList = [];

  @override
  void onInit() {
    super.onInit();
    getPreviewData();
  }

  var selectedMethod = RxInt(0);

  var paymentType = Rx<PaymentType>(
    PaymentType(
      onlinePayment: "online-payment",
      cash: 'cash',
    ),
  );

  String get selectedMethodText {
    totalPayable.value = 0.00;
    return selectedMethod.value == 0
        ? paymentType.value.cash
        : paymentType.value.onlinePayment;
  }

  void changePaymentMethod(int method) {
    selectedMethod.value = method;
  }

  void handlePaymentProcess() {
    if (selectedMethodText == 'cash') {
      cashBookedProcess();
    } else if (alias.value.contains('manual')) {
      paymentManualInsert();
    } else {
      bookingProcessAuto();
    }
  }

  ///=> GET ALL BOOKING PREVIEW INFO

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late BookingPreviewModel _bookingPreviewModel;

  BookingPreviewModel get bookingPreviewModel => _bookingPreviewModel;

  Future<BookingPreviewModel?> getPreviewData() async {
    return RequestProcess().request<BookingPreviewModel>(
      queryParams: {
        'token': dashboardController.carToken.value,
        'car_id': dashboardController.selectedCarId.value
      },
      fromJson: BookingPreviewModel.fromJson,
      apiEndpoint: ApiEndpoint.getBookingPreview,
      isLoading: _isLoading,
      showErrorMessage: false,
      onSuccess: (value) {
        _bookingPreviewModel = value!;
        _getPreviewALlData();
        _bookingPreviewModel.data.paymentGateways.forEach(
          (v) {
            paymentGatewayList.add(
              PaymentGateway(
                status: v.status,
                type: v.type,
                desc: v.desc,
                currencies: v.currencies,
                crypto: v.crypto,
                id: v.id,
                name: v.name,
              ),
            );
          },
        );
      },
    );
  }

  void _getPreviewALlData() {
    carModel.value = _bookingPreviewModel.data.car.carModel;
    carNumber.value = _bookingPreviewModel.data.car.carNumber;
    pickupTime.value = _bookingPreviewModel.data.bookingDetails.pickupTime;
    slug.value = _bookingPreviewModel.data.car.slug;
    Id.value = _bookingPreviewModel.data.car.id.toString();
    cashBalance.value = _bookingPreviewModel.data.paymentType.cash;
    onlinePayment.value = _bookingPreviewModel.data.paymentType.cash;
  }

  RxString paymentTypes = ''.obs;
  RxString alias = ''.obs;
  RxString currencyName = ''.obs;

  // RxString rate = ''.obs;
  RxString carModel = ''.obs;
  RxString carNumber = ''.obs;
  RxString pickupTime = ''.obs;
  RxString pickupDate = ''.obs;
  RxString slug = ''.obs;
  RxString Id = ''.obs;
  RxString cashBalance = ''.obs;
  RxString onlinePayment = ''.obs;

  ///=> CONFIRM BOOKING PROCESS

  final _isBookingLoading = false.obs;

  bool get isBookingLoading => _isBookingLoading.value;

  late BookingConfirmModel _bookingConfirmModel;

  BookingConfirmModel get bookingConfirmModel => _bookingConfirmModel;

  Future<BookingConfirmModel?> bookingProcessAuto() async {
    Map<String, dynamic> inputBody = {
      'location': Get.find<BookingController>().locationController.text,
      'destination': Get.find<BookingController>().destinationController.text,
      'distance': Get.find<BookingController>().distanceController.text,
      'message': Get.find<BookingController>().noteController.text,
      'round_pickup_time':
          Get.find<BookingController>().selectedRoundTime.value,
      'round_pickup_date':
          Get.find<BookingController>().selectedRoundDate.value,
      'mobile': Get.find<BookingController>().mobileController.text,
      'credentials': LocalStorage.email,
      'car_slug': slug.value,
      'car_id': Id.value,
      'gateway_type': paymentTypes.value,
      'gateway_currency': alias.value,
      'payment': selectedMethodText,
      'token': dashboardController.carToken.value,
      'fees': Get.find<BookingController>().totalFees.value.toString(),
      // 'transaction_id': fees.value,
    };
    return RequestProcess().request<BookingConfirmModel>(
      fromJson: BookingConfirmModel.fromJson,
      apiEndpoint: ApiEndpoint.bookingConfirm,
      isLoading: _isBookingLoading,
      method: HttpMethod.POST,
      body: inputBody,
      onSuccess: (value) {
        _bookingConfirmModel = value!;
        Get.to(() => WebPaymentScreen());
      },
    );
  }

  Future<CommonSuccessModel?> cashBookedProcess() async {
    Map<String, dynamic> inputBody = {
      'location': Get.find<BookingController>().locationController.text,
      'destination': Get.find<BookingController>().destinationController.text,
      'distance': Get.find<BookingController>().distanceController.text,
      'message': Get.find<BookingController>().noteController.text,
      'round_pickup_time':
          Get.find<BookingController>().selectedRoundTime.value,
      'round_pickup_date':
          Get.find<BookingController>().selectedRoundDate.value,
      'mobile': Get.find<BookingController>().mobileController.text,
      'credentials': LocalStorage.email,
      'car_slug': slug.value,
      'car_id': Id.value,
      'payment': selectedMethodText,
      'token': dashboardController.carToken.value,
      'fees': Get.find<BookingController>().totalFees.value.toString(),
    };
    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.bookingConfirm,
      isLoading: _isBookingLoading,
      method: HttpMethod.POST,
      body: inputBody,
      onSuccess: (value) {
        _commonSuccessModel = value!;
        _confirmation(_commonSuccessModel);
      },
    );
  }

  ///=> Get manual payment input field

  late ManualInputModel _manualInputModel;

  ManualInputModel get manualInputModel => _manualInputModel;

  Future<ManualInputModel?> paymentManualInsert() async {
    return RequestProcess().request<ManualInputModel>(
      fromJson: ManualInputModel.fromJson,
      apiEndpoint: ApiEndpoint.getManualPaymentField,
      isLoading: _isBookingLoading,
      showSuccessMessage: false,
      showResult: true,
      queryParams: {
        'alias': alias.value,
      },
      onSuccess: (value) {
        _manualInputModel = value!;
        var data = _manualInputModel.data.inputFields;
        getManualDynamicInputField(
          data: data,
          inputFieldControllers: inputFieldControllers,
          inputFields: inputFields,
          inputFileFields: inputFileFields,
          hasFile: hasFile,
          selectType: selectType,
        );
        Get.toNamed(Routes.paymentManualField);
      },
    );
  }

  ///=> manual payment process

  late CommonSuccessModel _commonSuccessModel;

  CommonSuccessModel get commonSuccessModel => _commonSuccessModel;

  Future<CommonSuccessModel?> bookingManualProcess() async {
    Map<String, String> inputBody = {
      'location': Get.find<BookingController>().locationController.text,
      'destination': Get.find<BookingController>().destinationController.text,
      'distance': Get.find<BookingController>().distanceController.text,
      'message': Get.find<BookingController>().noteController.text,
      'round_pickup_time':
          Get.find<BookingController>().selectedRoundTime.value,
      'round_pickup_date':
          Get.find<BookingController>().selectedRoundDate.value,
      'mobile': Get.find<BookingController>().mobileController.text,
      'credentials': LocalStorage.email,
      'car_slug': slug.value,
      'car_id': Id.value,
      'gateway_type': paymentTypes.value,
      'gateway_currency': alias.value,
      'payment': selectedMethodText,
      'token': dashboardController.carToken.value,
      'fees': Get.find<BookingController>().totalFees.value.toString(),
    };
    final data = _manualInputModel.data.inputFields;

    for (int i = 0; i < data.length; i += 1) {
      if (data[i].type != 'file') {
        inputBody[data[i].name] = inputFieldControllers[i].text;
      }
    }
    inputFileFields.clear();
    inputFields.clear();
    listImagePath.clear();
    listFieldName.clear();
    inputFieldControllers.clear();
    update();

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.bookingConfirm,
      isLoading: _isBookingLoading,
      method: HttpMethod.POST,
      body: inputBody,
      fieldList: listFieldName,
      pathList: listImagePath,
      onSuccess: (value) {
        inputFileFields.clear();
        inputFields.clear();
        listImagePath.clear();
        listFieldName.clear();
        inputFieldControllers.clear();
        update();
        _commonSuccessModel = value!;
        _confirmation(_commonSuccessModel);
      },
    );
  }

  void _confirmation(CommonSuccessModel commonSuccessModel) {
    Congratulation congratulation = Congratulation(
      details: Strings.bookingSuccessfully,
      route: Routes.dashboardScreen,
      buttonText: Strings.backToHome,
      type: Strings.payment,
    );

    Get.to(
      () => CongratulationsScreen(),
      arguments: congratulation,
    );
  }

  RxDouble totalPayable = 0.0.obs;

  RxDouble exRent = 0.0.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble fixeCharge = 0.0.obs;
  RxDouble conversionAmount = 0.0.obs;
  RxDouble totalCharge = 0.0.obs;

  void calculateAllCharges() {
    conversionAmount.value =
        exRent.value * Get.find<BookingController>().totalFees.value;

    // Calculate the percent charge based on the conversion amount
    percentCharge.value = percentCharge.value / 100 * conversionAmount.value;

    // Calculate the total charge
    totalCharge.value = fixeCharge.value + percentCharge.value;

    // Calculate the total payable amount
    totalPayable.value = conversionAmount.value + totalCharge.value;
  }
}
