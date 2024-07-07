import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/notifications/domain/notify_repo.dart';

import '../../../core/utils/Locator.dart';
import 'notifications_states.dart';

class NotifyCubit extends Cubit<NotificationsState> {
  NotifyCubit() : super(NotificationsInitial());
  static NotifyCubit get(context) => BlocProvider.of(context);
  NotifyRepo notifyRepo = NotifyRepo(locator<DioService>());
  getnotificationsData() async {
    emit(NotificationsLoading());
    final response = await notifyRepo.getNotifications();
    if (response != null) {
      emit(NotificationsLoaded());
      return response;
    } else {
      emit(NotificationsFailed());
      return null;
    }
  }
}
// }
