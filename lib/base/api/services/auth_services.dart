import 'package:carbo/base/extensions/extensions.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import '../../../views/auth/login/model/log_in_model.dart';
import '../../../views/auth/register/model/register_model.dart';
import '../../../views/auth/reset_password/model/find_user_send_code_model.dart';
import '../../../views/auth/reset_password/model/forgot_pass_and_verify_model.dart';
import '../../utils/local_storage.dart';
import '../endpoint/api_endpoint.dart';
import '../method/request_process.dart';
import '../model/common_success_model.dart';

class AuthServices {
  static late LogInModel _logInModel;

  LogInModel get logInModel => _logInModel;

  static late RegisterModel _registerModel;

  RegisterModel get registerModel => _registerModel;

  static late FindUserSendCodeModel _findUserSendCodeModel;

  FindUserSendCodeModel get findUserSendCodeModel => _findUserSendCodeModel;
  static late ForgotPasswordAndVerifyModel _forgotPasswordAndVerifyModel;

  ForgotPasswordAndVerifyModel get forgotPasswordAndVerifyModel =>
      _forgotPasswordAndVerifyModel;

  static late CommonSuccessModel _commonSuccessModel;

  CommonSuccessModel get commonSuccessModel => _commonSuccessModel;

// LOGIN SERVICE - - - - - - - - - - - - - - - - -
  static Future<LogInModel?> logInService({
    required String credentials,
    required String password,
    required RxBool isLoading,
  }) async {
    Map<String, dynamic> inputBody = {
      'credentials': credentials,
      'password': password,
    };
    return RequestProcess().request<LogInModel>(
      fromJson: LogInModel.fromJson,
      apiEndpoint: ApiEndpoint.login,
      isLoading: isLoading,
      method: HttpMethod.POST,
      body: inputBody,
      isBasic: true,
      onSuccess: (value) {
        _logInModel = value!;
        var data = _logInModel.data;
        LocalStorage.save(
          token: data.token,
          temporaryToken: data.authorization.token,
          isEmailVerified: data.userInfo.emailVerified == 1,
          email: data.userInfo.email,
          kycStatus: data.userInfo.kycVerified,
        );
        if (data.userInfo.emailVerified == 1) {
          if (data.userInfo.twoFactorStatus == 1 &&
              data.userInfo.twoFactorVerified == 0) {
            Get.toNamed(Routes.dashboardScreen);
            LocalStorage.save(
              isLoggedIn: true,
            );
          } else {
            Get.offAllNamed(Routes.dashboardScreen);
            LocalStorage.save(
              isLoggedIn: true,
            );
          }
        } else {
          Get.toNamed(Routes.register_otp_verificationScreen);
        }
      },
    );
  }

// LOG OUT SERVICE - - - - - - - - - - - - - - - - -
  static Future<CommonSuccessModel?> logOutService({
    required RxBool isLoading,
  }) async {
    Map<String, dynamic> inputBody = {};
    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.logOut,
      isLoading: isLoading,
      method: HttpMethod.POST,
      body: inputBody,
      onSuccess: (value) {
        _commonSuccessModel = value!;
        Get.offAllNamed(Routes.loginScreen);
        LocalStorage.clear();
      },
    );
  }

  // REGISTER SERVICE - - - - - - - - - - - - - - - - -
  static Future<RegisterModel?> registrationProcess({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String country,
    required RxBool isLoading,
  }) async {
    Map<String, dynamic> inputBody = {
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'password': password,
      'country': country,
      'agree': 'on',
    };
    return RequestProcess().request<RegisterModel>(
      fromJson: RegisterModel.fromJson,
      apiEndpoint: ApiEndpoint.register,
      isLoading: isLoading,
      method: HttpMethod.POST,
      body: inputBody,
      isBasic: true,
      onSuccess: (value) {
        _registerModel = value!;
        var data = _registerModel.data;
        LocalStorage.save(
          token: data.token,
          temporaryToken: data.authorization.token,
          isLoggedIn: true,
          isKycVerified: data.userInfo.kycVerified == 1,
          isEmailVerified: data.userInfo.emailVerified == 1,
          kycStatus: data.userInfo.kycVerified,
        );
        if (data.userInfo.emailVerified == 0) {
          if (data.userInfo.kycVerified == 0) {
            Routes.register_otp_verificationScreen.toNamed;
            LocalStorage.save(isLoggedIn: true);
          } else {
            Routes.dashboardScreen.toNamed;
            LocalStorage.save(isLoggedIn: true);
          }
        } else {
          Routes.dashboardScreen.toNamed;
        }
      },
    );
  }

// FORGOT PASSWORD SERVICE - - - - - - - - - - - - - - - - -
  static Future<FindUserSendCodeModel?> forgotPasswordProcess({
    required String credentials,
    required RxBool isLoading,
  }) async {
    Map<String, dynamic> inputBody = {
      'credentials': credentials,
    };
    return RequestProcess().request<FindUserSendCodeModel>(
      fromJson: FindUserSendCodeModel.fromJson,
      apiEndpoint: ApiEndpoint.forgotPassword,
      isLoading: isLoading,
      method: HttpMethod.POST,
      isBasic: true,
      body: inputBody,
      onSuccess: (value) {
        _findUserSendCodeModel = value!;
        var data = _findUserSendCodeModel.data;
        LocalStorage.save(
          temporaryToken: data.token,
        );
        Get.toNamed(Routes.otp_verificationScreen);
      },
    );
  }

// RESEND PASSWORD SERVICE - - - - - - - - - - - - - - - - -
  static Future<CommonSuccessModel?> resendForgotOtpCode({
    required RxBool isResendLoading,
  }) async {
    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.resendForgotOtpCode,
      queryParams: {'token': LocalStorage.temporaryToken},
      isLoading: isResendLoading,
      onSuccess: (value) {
        _commonSuccessModel = value!;
      },
    );
  }

// OTP VERIFICATION SERVICE - - - - - - - - - - - - - - - - -
  static Future<ForgotPasswordAndVerifyModel?> otpVerifyProcess({
    required String code,
    required RxBool isLoading,
  }) async {
    Map<String, dynamic> inputBody = {
      'token': LocalStorage.temporaryToken,
      'code': code,
    };

    return RequestProcess().request<ForgotPasswordAndVerifyModel>(
      fromJson: ForgotPasswordAndVerifyModel.fromJson,
      apiEndpoint: ApiEndpoint.forgotPasswordVerifyCode,
      isLoading: isLoading,
      method: HttpMethod.POST,
      body: inputBody,
      onSuccess: (value) {
        _forgotPasswordAndVerifyModel = value!;
        Routes.new_passwordScreen.toNamed;
      },
    );
  }

  // RESET PASSWORD SERVICE - - - - - - - - - - - - - - - - -
  static Future<CommonSuccessModel?> resetPasswordProcess({
    required RxBool isLoading,
    required String password,
    required String confirmPassword,
  }) async {
    Map<String, dynamic> inputBody = {
      'token': LocalStorage.temporaryToken,
      'password': password,
      'password_confirmation': confirmPassword,
    };
    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.resetPassword,
      isLoading: isLoading,
      method: HttpMethod.POST,
      body: inputBody,
      showSuccessMessage: true,
      onSuccess: (value) {
        Get.offAllNamed(Routes.loginScreen);
      },
    );
  }

  // EMAIL VERIFY SERVICE - - - - - - - - - - - - - - - - -
  static Future<CommonSuccessModel?> emailVerifyProcess({
    required String code,
    required RxBool isLoading,
  }) async {
    Map<String, dynamic> inputBody = {
      'token': LocalStorage.temporaryToken,
      'code': code,
    };

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.emailOtpVerify,
      isLoading: isLoading,
      method: HttpMethod.POST,
      body: inputBody,
      onSuccess: (value) {
        _commonSuccessModel = value!;
        Routes.dashboardScreen.offAllNamed;
        LocalStorage.save(
          isLoggedIn: true,
        );
        // if (LocalStorage.kycStatus == 0) {
        //   Routes.kycInformationScreen.toNamed;
        // } else {
        //
        // }
      },
    );
  }

  // RESEND OTP CODE - - - - - - - - - - - - - - - - -
  static Future<CommonSuccessModel?> resendEmailOtpCode({
    required RxBool isResendLoading,
  }) async {
    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.resendEmailOtp,
      queryParams: {'token': LocalStorage.temporaryToken},
      isLoading: isResendLoading,
      onSuccess: (value) {
        _commonSuccessModel = value!;
      },
    );
  }

  // DELETE ACCOUNT SERVICE - - - - - - - - - - - - - - - - -
  static Future<CommonSuccessModel?> deleteAccountServices({
    required RxBool isLoading,
  }) async {
    Map<String, dynamic> inputBody = {};
    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.deleteAccount,
      isLoading: isLoading,
      method: HttpMethod.POST,
      body: inputBody,
      onSuccess: (value) {
        _commonSuccessModel = value!;
        Get.offAllNamed(Routes.loginScreen);
        LocalStorage.clear();
      },
    );
  }
}
