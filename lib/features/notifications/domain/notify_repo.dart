import 'package:remontada/core/data_source/dio_helper.dart';

import 'model/notify_model.dart';

class NotifyRepo {
  DioService dioService;
  NotifyRepo(this.dioService);

  Future<PaginationNotificationModel?> getNotificationRequest({
    required int page,
  }) async {
    final response = await dioService.getData(
      url: "/notifications",
      query: {
        'page': page,
      },
    );
    if (response.isError == false) {
      return PaginationNotificationModel.fromJson(response.response?.data);
    } else {
      return null;
    }
  }
}
