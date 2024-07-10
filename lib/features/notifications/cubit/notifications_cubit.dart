import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/notifications/domain/notify_repo.dart';

import '../../../core/utils/Locator.dart';
import '../domain/model/notify_model.dart';
import 'notifications_states.dart';

class NotifyCubit extends Cubit<NotificationsState> {
  NotifyCubit() : super(NotificationsInitial());
  static NotifyCubit get(context) => BlocProvider.of(context);
  NotifyRepo notifyRepo = NotifyRepo(locator<DioService>());
  PagingController<int, NotificationModel> notificationController =
      PagingController<int, NotificationModel>(firstPageKey: 1);
  addPageLisnter() async {
    notificationController.addPageRequestListener((pageKey) {
      getNotification(page: pageKey);
    });
  }

  getNotification({required int page}) async {
    final res = await notifyRepo.getNotificationRequest(
      page: page,
    );
    if (res != null) {
      var isLastPage = res.page == page;

      if (isLastPage) {
        // stop
        notificationController.appendLastPage(res.notification ?? []);
      } else {
        // increase count to reach new page
        var nextPageKey = page + 1;
        notificationController.appendPage(res.notification ?? [], nextPageKey);
      }
      // emit(NewState());
    } else {
      notificationController.error = 'error';
    }
  }
}
// }
