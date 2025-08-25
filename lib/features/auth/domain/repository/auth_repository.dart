import 'dart:developer';

import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/auth/domain/model/auth_model.dart';

import '../../../../core/data_source/dio_helper.dart';
import '../request/auth_request.dart';
import 'end_points.dart';

class AuthRepository {
  final DioService dioService;
  AuthRepository(this.dioService);

  Future<Areas?> getArreasRequest({
    final bool loading = false,
  }) async {
    final response = await dioService.getData(
      url: AuthEndPoints.area,
      loading: loading,
    );
    if (response.isError == false) {
      return Areas.fromMap(response.response?.data["data"]);
    } else {
      return null;
    }
  }

  Future<Areas?> getPlaygrounds({
    final bool loading = false,
  }) async {
    final response = await dioService.getData(
      url: "/playgrounds",
      loading: loading,
    );
    if (response.isError == false) {
      return Areas.fromMap(response.response?.data["data"]);
    } else {
      return null;
    }
  }

  Future<Locations?> getlocationRequest() async {
    final ApiResponse response = await dioService.getData(
      url: AuthEndPoints.location,
    );
    log("failed", name: "1");
    if (response.isError == false) {
      log("success", name: "2");
      final Map<String, dynamic> res =
          response.response?.data["data"] as Map<String, dynamic>;
      return Locations.fromMap(response.response?.data["data"]);
    } else {
      log("failed", name: "3");
      return null;
    }
  }

  loginRequest(AuthRequest user) async {
    final response = await dioService.postData(
      isForm: true,
      url: AuthEndPoints.login,
      body: user.login(),
      loading: true,
    );
    if (response.isError == false) {
      return response.response?.data['data'];
    } else {
      // if (response.response?.statusCode == 307) {
      //   return true;
      // }
      return null;
    }
  }

  registerRequest(AuthRequest user) async {
    print('RegisterRequest: Sending data:');
    print(user.register());
    final response = await dioService.postData(
        isForm: true,
        url: AuthEndPoints.register,
        body: user.register(),
        loading: true);
    print('RegisterRequest: Raw response:');
    print(response.response?.data);
    print('RegisterRequest: isError: ${response.isError}');
    if (response.isError == false) {
      print('RegisterRequest: Success, data:');
      print(response.response?.data['data']);
      return response.response?.data['data'];
    } else {
      print('RegisterRequest: Error, message:');
      print(response.response?.data['message']);
      return null;
    }
  }

  resendCodeRequest(String phone) async {
    final response = await dioService.postData(
      url: AuthEndPoints.resendCode,
      body: {'mobile': phone},
      isForm: true,
    );
    if (response.isError == false) {
      // Alerts.snack(text: response.response?.data['message'], state: 1);
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  sendCodeRequest({
    required String phone,
    required String code,
  }) async {
    final response = await dioService.postData(
      url: AuthEndPoints.sendCode,
      body: {
        'mobile': phone,
        'code': code,
        "device_token": Utils.FCMToken,
        "device_type": Utils.deviceType,
        "uuid": Utils.uuid,
      },
      loading: true,
      isForm: true,
    );
    if (response.isError == false) {
      // Alerts.snack(text: response.response?.data['message'], state: 1);
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  // forgetPassRequest(String email) async {
  //   final response = await dioService.postData(
  //     url: AuthEndPoints.forgetPassword,
  //     body: {'email': email},
  //     isForm: true,
  //     loading: true,
  //   );
  //   if (response.isError == false) {
  //     Alerts.snack(
  //         text: response.response?.data['message'], state: SnackState.success);
  //     return response.response?.data['data'];
  //   } else {
  //     Alerts.snack(
  //         text: response.response?.data['message'], state: SnackState.failed);
  //     return null;
  //   }
  // }

  // resetPassword({
  //   required String code,
  //   required String pass,
  //   required String email,
  // }) async {
  //   final response = await dioService.postData(
  //     url: AuthEndPoints.resetPassword,
  //     body: {
  //       'code_id': code,
  //       'password': pass,
  //       'email': email,
  //     },
  //     isForm: true,
  //     loading: true,
  //   );
  //   if (response.isError == false) {
  //     Alerts.snack(
  //         text: response.response?.data['message'], state: SnackState.success);
  //     return true;
  //   } else {
  //     Alerts.snack(
  //         text: response.response?.data['message'], state: SnackState.failed);
  //     return null;
  //   }
  // }
}
