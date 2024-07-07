import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/notifications/domain/end_points.dart';

class NotifyRepo {
  DioService dioService;
  NotifyRepo(this.dioService);

  getNotifications() async {
    final ApiResponse response = await dioService.getData(
      url: NotifyEndpoints.notifications,
    );
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }
}
