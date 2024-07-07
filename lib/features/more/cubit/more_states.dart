abstract class MoreStates {}

class MoreInitial extends MoreStates {}

final class GetNotificationPermission extends MoreStates {
  final bool? notificationPermision;
  GetNotificationPermission({this.notificationPermision});
}

final class LogOutLoading extends MoreStates {}

final class LogOutSuccess extends MoreStates {}

final class LogOutFailed extends MoreStates {}
