abstract class MoreStates {}

class MoreInitial extends MoreStates {}

final class GetNotificationPermission extends MoreStates {
  final bool? notificationPermision;
  GetNotificationPermission({this.notificationPermision});
}

final class LogOutLoading extends MoreStates {}

final class LogOutSuccess extends MoreStates {}

final class LogOutFailed extends MoreStates {}

final class CoachLoading extends MoreStates {}

final class CoachLoadedSuccess extends MoreStates {}

final class CoachFailed extends MoreStates {}

final class ProfileLoad extends MoreStates {}

final class ProfileSuccess extends MoreStates {}

final class ProfileFailed extends MoreStates {}
