import 'dart:io';
import 'package:carbo/base/utils/basic_import.dart';
import 'package:carbo/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../base/api/endpoint/api_endpoint.dart';
import '../../../base/api/method/request_process.dart';
import '../../../base/api/model/common_success_model.dart';
import '../../../base/utils/local_storage.dart';
import '../../auth/register/controller/register_controller.dart';
import '../model/profile_info_model.dart';

class UpdateProfileController extends GetxController {
  final regController = Get.put(RegisterController());
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  final addressController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  RxBool isFormValid = false.obs;
  List<Country> countryList = [];

  RxString countrySelectMethod = ''.obs;
  RxString userEmail = ''.obs;
  RxString userCountry = Strings.locationNotAbleAble.obs;
  RxString userCity = ''.obs;
  RxString mobileCode = ''.obs;
  RxBool isAvailableUserImage = false.obs;
  RxString userImage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    firstNameController.addListener(_updateFormValidity);
    lastNameController.addListener(_updateFormValidity);
    getProfileInfo();
  }

  void _updateFormValidity() {
    isFormValid.value = firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty;
  }

  // Get Profile Info
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late ProfileInfoModel _profileInfoModel;

  ProfileInfoModel get profileInfoModel => _profileInfoModel;

  Future<ProfileInfoModel?> getProfileInfo() async {
    return RequestProcess().request<ProfileInfoModel>(
      fromJson: ProfileInfoModel.fromJson,
      apiEndpoint: ApiEndpoint.profileInfo,
      isLoading: _isLoading,
      onSuccess: (value) {
        _profileInfoModel = value!;
        _setProfileData();
      },
    );
  }

  void _setProfileData() {
    var userInfo = _profileInfoModel.data.userInfo;
    var imagePaths = _profileInfoModel.data.imagePaths;
    firstNameController.text = userInfo.firstname;
    lastNameController.text = userInfo.lastname;
    zipCodeController.text = userInfo.postalCode;
    addressController.text = userInfo.address;
    cityController.text = userInfo.city;
    mobileController.text = userInfo.mobile ?? '';
    stateController.text = userInfo.state;
    countrySelectMethod.value = userInfo.country;
    userCity.value = userInfo.city;
    mobileCode.value = userInfo.mobileCode ?? '';
    LocalStorage.save(email: userInfo.email);
    if (userInfo.image != '') {
      userImage.value =
          "${imagePaths.baseUrl}/${imagePaths.pathLocation}/${userInfo.image}";

      isAvailableUserImage.value = true;
    } else {
      userImage.value = "${imagePaths.baseUrl}/${imagePaths.defaultImage}";
    }

    _profileInfoModel.data.countries.forEach((element) {
      countryList.add(
        Country(
          id: element.id,
          name: element.name,
          mobileCode: element.mobileCode,
          currencyName: element.currencyName,
          currencyCode: element.currencyCode,
          currencySymbol: element.currencySymbol,
        ),
      );
    });
  }

  // Profile Update

  final _isUpdateLoading = false.obs;

  bool get isUpdateLoading => _isUpdateLoading.value;

  late CommonSuccessModel _commonSuccessModel;

  CommonSuccessModel get commonSuccessModel => _commonSuccessModel;

  Future<CommonSuccessModel?> updateProfile() async {
    Map<String, dynamic> inputBody = {
      'firstname': firstNameController.text,
      'lastname': lastNameController.text,
      'mobile_code': mobileCode.value,
      'mobile': mobileController.text,
      'city': cityController.text,
      'state': stateController.text,
      'postal_code': zipCodeController.text,
      'address': addressController.text,
      'country': countrySelectMethod.value,
    };

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.updateProfile,
      isLoading: _isUpdateLoading,
      method: HttpMethod.POST,
      fieldList: isImagePathSet.value ? ['image'] : null,
      pathList: isImagePathSet.value ? [imagePath.value] : null,
      body: inputBody,
      showSuccessMessage: true,
      onSuccess: (value) {
        _commonSuccessModel = value!;
        LocalStorage.save(number: mobileController.text);
        Get.offAllNamed(Routes.dashboardScreen);
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    firstNameController.removeListener(_updateFormValidity);
    lastNameController.removeListener(_updateFormValidity);
    mobileController.removeListener(_updateFormValidity);
  }

  // Set Image
  File? pickedFile;
  ImagePicker imagePicker = ImagePicker();
  var isImagePathSet = false.obs;
  var imagePath = "".obs;

  void setImagePath(String path) {
    imagePath.value = path;
    isImagePathSet.value = true;
  }

  // image picker function
  Future pickImage(imageSource) async {
    try {
      final image = await ImagePicker().pickImage(
        source: imageSource,
        imageQuality: 40,
        maxHeight: 600,
        maxWidth: 600,
      );
      if (image == null) return;
      pickedFile = File(image.path);
      setImagePath(pickedFile!.path);
    } on PlatformException catch (e) {
      CustomSnackBar.error('Error: $e');
    }
  }
}
