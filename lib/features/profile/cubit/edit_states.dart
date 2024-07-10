import 'package:remontada/features/auth/domain/model/auth_model.dart';

abstract class EditState {}

class EditInitial extends EditState {}

class EditLoading extends EditState {}

class EditSuccess extends EditState {
  User user;
  EditSuccess(this.user);
}

class EditFailed extends EditState {}

class ProfileLoading extends EditState {}

class ProfileLoaded extends EditState {
  User user;
  ProfileLoaded(this.user);
}

class ProfileFailed extends EditState {}
