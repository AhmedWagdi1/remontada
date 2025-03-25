import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data_source/dio_helper.dart';
import '../../../core/utils/Locator.dart';
import '../../../core/utils/firebase_message.dart';
import '../../../core/utils/utils.dart';
import '../../auth/domain/request/auth_request.dart';
import '../domain/repository/auth_repository.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  AuthRepository authRepository = AuthRepository(locator<DioService>());

  login({required AuthRequest loginRequestModel}) async {
    emit(LoginLoadingState());
    final response = await authRepository.loginRequest(loginRequestModel);
    if (response != null) {
      if (response is bool) {
        emit(NeedRegister());
      } else if (response['code'] == null) {
        emit(LoginErrorState());
        return false;
      } else {
        emit(LoginSuccessState());
        return true;
      }
    } else {
      emit(LoginErrorState());
      return null;
    }
  }

  signUp({required AuthRequest registerRequestModel}) async {
    emit(RegisterLoadingState());
    final response = await authRepository.registerRequest(registerRequestModel);
    if (response != null) {
      emit(RegisterSuccessState());
      log("success");
      return true;
    } else {
      emit(RegisterErrorState());
      log("failed");

      return false;
    }
  }

  resendCode(String mobile) async {
    emit(ResendCodeLoadingState());
    final response = await authRepository.resendCodeRequest(mobile);
    if (response != null) {
      emit(ResendCodeSuccessState());

      return true;
    } else {
      emit(ResendCodeErrorState());
      return null;
    }
  }

  // forgetPass(String forgetPass) async {
  //   emit(ForgetPassLoadingState());
  //   var res = await authRepository.forgetPassRequest(forgetPass);
  //   if (res != null) {
  //     emit(ForgetPassSuccessState());
  //     return true;
  //   } else {
  //     emit(ForgetPassErrorState());
  //     return null;
  //   }
  // }

  String codeId = "";
  sendCode({required String phone, required String code}) async {
    emit(ActivateCodeLoadingState());
    if (Utils.FCMToken.isEmpty) {
      await FBMessging.getToken();
    }
    final response = await authRepository.sendCodeRequest(
      phone: phone,
      code: code,
    );
    if (response != null) {
      codeId = response['code'].toString();
      await Utils.saveUserInHive(response);
      emit(ActivateCodeSuccessState());
      return true;
    } else {
      emit(ActivateCodeErrorState());
      return null;
    }
  }

  // resetPassword({
  //   required String code,
  //   required String pass,
  //   required String email,
  // }) async {
  //   emit(ResetPasswordLoadingState());
  //   var res = await authRepository.resetPassword(
  //     code: code,
  //     pass: pass,
  //     email: email,
  //   );
  //   if (res != null) {
  //     emit(ResetPasswordSuccessState());
  //     return res;
  //   } else {
  //     emit(ResetPasswordErrorState());
  //     return null;
  //   }
  // }

  // Future<Areas> getAreas() async {
  //   final res = authRepository.getArreasRequest();
  //   if (res != null) {
  //     return await Areas.fromMap(res);
  //   } else {
  //     return Areas();
  //   }
}

//   Future<Locations> getlocations() async {
//     final res = authRepository.getlocationRequest();

//     if (res != null) {
//       log("$res");
//       return Locations.fromMap(res);
//     } else {
//       log(res);
//       return Locations();
//     }
//   }
// }
