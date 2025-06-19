import 'package:carbo/base/utils/basic_import.dart';
import 'package:carbo/views/dashboard/model/area_has_type_model.dart';
import 'package:carbo/views/dashboard/model/car_area_model.dart';
import 'package:dynamic_languages/dynamic_languages.dart';
import '../../../base/api/endpoint/api_endpoint.dart';
import '../../../base/api/method/request_process.dart';
import '../model/car_info_model.dart';
import '../model/dashboard_info_model.dart';

class DashboardController extends GetxController {
  final List<String> carType = [];

  RxInt currentIndex = 0.obs;
  RxString selectedDate = ''.obs;
  RxString selectedTime = ''.obs;
  RxString userFullName = ''.obs;
  RxString userEmail = ''.obs;
  RxString userName = ''.obs;
  RxString userDefaultImageUrl = ''.obs;
  RxString userProfileImage = ''.obs;
  RxString selectedCarId = ''.obs;
  RxString carToken = ''.obs;
  var selectedCarIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getDashboardInfo();
  }

  void clearData() {
    cars.clear();
    selectedTime.value = '';
    selectedDate.value = '';
  }

  // Get Dashboard Info
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  late DashboardInfoModel _dashboardInfoModel;

  DashboardInfoModel get dashboardInfoModel => _dashboardInfoModel;

  Future<DashboardInfoModel?> getDashboardInfo() async {
    return RequestProcess().request<DashboardInfoModel>(
      fromJson: DashboardInfoModel.fromJson,
      apiEndpoint: ApiEndpoint.dashboardInfo,
      isLoading: _isLoading,
      showErrorMessage: false,
      onSuccess: (value) {
        _dashboardInfoModel = value!;
        _getDashboardInfo();
        areaList.clear();
        typeList.clear();
        getArea();
      },
    );
  }

  void _getDashboardInfo() {
    var baseUrl = _dashboardInfoModel.data.profileImagePaths.baseUrl;
    var path = _dashboardInfoModel.data.profileImagePaths.pathLocation;
    var img = _dashboardInfoModel.data.userInfo.image;
    var defaultImg = _dashboardInfoModel.data.profileImagePaths.defaultImage;
    userProfileImage.value = '${baseUrl}/$path/$img';
    userDefaultImageUrl.value = '${baseUrl}/$defaultImg';
    userFullName.value = _dashboardInfoModel.data.userInfo.fullname;
    userEmail.value = _dashboardInfoModel.data.userInfo.email;
  }

  //// GET ARE - - - - - - - - - - - - - - - - -
  Rxn<Datum> selectedArea = Rxn<Datum>();
  final List<Datum> areaList = [];

  RxInt areaId = 0.obs;
  RxString selectArea = ''.obs;

  late CarAreaModel _carAreaModel;

  CarAreaModel get carAreaModel => _carAreaModel;

  Future<CarAreaModel?> getArea() async {
    return RequestProcess().request<CarAreaModel>(
      fromJson: CarAreaModel.fromJson,
      apiEndpoint: ApiEndpoint.getArea,
      isLoading: _isLoading,
      showErrorMessage: false,
      onSuccess: (value) {
        _carAreaModel = value!;
        selectArea.value = _carAreaModel.data.first.name;
        _carAreaModel.data.forEach(
          (v) {
            areaList.add(
              Datum(
                name: v.name,
                status: v.status,
                createdAt: v.createdAt,
                id: v.id,
                lastEditBy: v.lastEditBy,
                slug: v.slug,
                updatedAt: v.updatedAt,
              ),
            );
          },
        );
      },
    );
  }

  // AREA HAS TYPE POST - - - - - - - - - - - - - - - - -
  RxInt carTypeId = 0.obs;
  RxString alis = ''.obs;

  Rxn<TypesAll> selectType = Rxn<TypesAll>();
  final List<TypesAll> typeList = [];

  final _isLoad = false.obs;

  bool get isLoad => _isLoad.value;

  late AreaHasTypeModel _areaHasTypeModel;

  AreaHasTypeModel get areaHasTypeModel => _areaHasTypeModel;

  Future<AreaHasTypeModel?> areaHasType() async {
    Map<String, dynamic> inputBody = {
      'area': areaId.value.toString(),
    };
    return RequestProcess().request<AreaHasTypeModel>(
      fromJson: AreaHasTypeModel.fromJson,
      apiEndpoint: ApiEndpoint.postAreaHasType,
      isLoading: _isLoad,
      method: HttpMethod.POST,
      showResult: true,
      body: inputBody,
      onSuccess: (value) {
        _areaHasTypeModel = value!;
        _areaHasTypeModel.data.area.typesAll?.forEach(
          (v) {
            typeList.add(
              TypesAll(
                  name: v.type?.name,
                  id: v.id,
                  updatedAt: v.updatedAt,
                  createdAt: v.createdAt,
                  type: v.type,
                  carTypeId: v.carTypeId,
                  carAreaId: v.carAreaId),
            );
          },
        );
      },
    );
  }

// =  SEARCH CAR API

  var cars = <Car>[].obs;
  RxString carImgUrl = ''.obs;
  final _isSearchingCar = false.obs;

  bool get isSearchingCar => _isSearchingCar.value;

  late CarInfoModel _carInfoModel;

  CarInfoModel get carInfoModel => _carInfoModel;

  Future<CarInfoModel?> searchAllCar() async {
    cars.clear();
    Map<String, dynamic> inputBody = {
      'car_area': areaId.value,
      'car_type': carTypeId.value,
      'pickup_time': selectedTime.value,
      'pickup_date': selectedDate.value,
    };
    return RequestProcess().request<CarInfoModel>(
      fromJson: CarInfoModel.fromJson,
      apiEndpoint: ApiEndpoint.searchCar,
      isLoading: _isSearchingCar,
      method: HttpMethod.POST,
      body: inputBody,
      showResult: true,
      onSuccess: (value) {
        _carInfoModel = value!;
        carToken.value = _carInfoModel.data.token;

        carImgUrl.value =
            '${_carInfoModel.data.dataPath.baseUrl}/${_carInfoModel.data.dataPath.imagePath}/';
        _carInfoModel.data.cars.forEach(
          (element) {
            cars.add(
              Car(
                  carAreaId: element.carAreaId,
                  id: element.id,
                  carTypeId: element.carTypeId,
                  carNumber: element.carNumber,
                  slug: element.slug,
                  status: element.status,
                  fees: element.fees,
                  image: element.image,
                  approval: element.approval,
                  carModel: element.carModel,
                  createdAt: element.createdAt,
                  experience: element.experience,
                  seat: element.seat,
                  updatedAt: element.updatedAt,
                  vendorId: element.vendorId,
                  carTitle: element.carTitle),
            );
          },
        );
        if (cars.isEmpty) {
          CustomSnackBar.error(
            DynamicLanguage.isLoading
                ? ""
                : DynamicLanguage.key(Strings.noCarFindMessage),
          );
        }
      },
    );
  }
}
