import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/features/more/cubit/more_states.dart';
import 'package:remontada/features/more/domain/contact_request.dart';
import 'package:remontada/features/more/domain/model/model.dart';
import 'package:remontada/features/more/domain/more_repo.dart';

import '../../../core/utils/utils.dart';

class MoreCubit extends Cubit<MoreStates> {
  MoreCubit() : super(MoreInitial());
  MoreRepo moreRepo = MoreRepo(locator<DioService>());

  static MoreCubit get(context) => BlocProvider.of(context);
  Future<bool?> checkNotificationEnabled() async {
    var androidPlugin = FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    bool? notificationEnabled = await androidPlugin?.areNotificationsEnabled();

    return notificationEnabled;
  }

  logOut() async {
    emit(LogOutLoading());
    final response = await moreRepo.logout();

    if (response != null) {
      Utils.dataManager.deleteUserData();

      emit(LogOutSuccess());
      return true;
    } else {
      emit(LogOutFailed());
      return null;
    }
  }

  getAbout() async {
    final res = await moreRepo.getAboutpage();
    if (res != null) {
      return Pages.fromMap(res["page"]);
    } else {
      return null;
    }
  }

  getpolicy() async {
    final res = await moreRepo.getPolicy();
    if (res != null) {
      return Pages.fromMap(res["page"]);
    } else {
      return null;
    }
  }

  requestCoach() async {
    emit(CoachLoading());
    final res = await moreRepo.coachRequest();

    if (res != null) {
      emit(CoachLoadedSuccess());
      return true;
    } else {
      emit(CoachFailed());
      return null;
    }
  }

  contactRequest(ContactRequest request) async {
    final res = await moreRepo.contactUs(request);
    if (res != null) {
      return true;
    } else {
      return null;
    }
  }
}
