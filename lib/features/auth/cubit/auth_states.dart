import 'package:remontada/features/auth/domain/model/auth_model.dart';

abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

class LoginErrorState extends AuthStates {}

class RegisterLoadingState extends AuthStates {}

class RegisterSuccessState extends AuthStates {}

class RegisterErrorState extends AuthStates {}

class ResendCodeLoadingState extends AuthStates {}

class ResendCodeSuccessState extends AuthStates {}

class ResendCodeErrorState extends AuthStates {}

class ForgetPassLoadingState extends AuthStates {}

class ForgetPassSuccessState extends AuthStates {}

class ForgetPassErrorState extends AuthStates {}

class ActivateCodeLoadingState extends AuthStates {}

class ActivateCodeSuccessState extends AuthStates {}

class ActivateCodeErrorState extends AuthStates {}

class ResetPasswordLoadingState extends AuthStates {}

class ResetPasswordSuccessState extends AuthStates {}

class ResetPasswordErrorState extends AuthStates {}

class Areassuccess extends AuthStates {
  final Areas areas;
  Areassuccess(this.areas);
}

class AreaFailed extends AuthStates {}

class Locationsssuccess extends AuthStates {
  final Locations locations;
  Locationsssuccess(this.locations);
}

class LocationsFailed extends AuthStates {}

class NeedRegister extends AuthStates {}
