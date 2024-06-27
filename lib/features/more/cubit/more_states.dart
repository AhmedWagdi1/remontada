abstract class MoreStates {}

class MoreInitial extends MoreStates {}

final class GetNotificationPermission extends MoreStates {
  final bool? notificationPermision;
  GetNotificationPermission({this.notificationPermision});
}
