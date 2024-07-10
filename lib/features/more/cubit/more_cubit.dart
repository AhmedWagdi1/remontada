import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/features/more/cubit/more_states.dart';
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
    log(Utils.lang);
    final response = await moreRepo.logout();
    if (response != null) {
      emit(LogOutSuccess());
      Utils.dataManager.deleteUserData();
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
}
