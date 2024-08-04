import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/core/utils/firebase_message.dart';
import 'package:remontada/features/more/cubit/more_states.dart';
import 'package:remontada/features/more/domain/contact_request.dart';
import 'package:remontada/features/more/domain/model/model.dart';
import 'package:remontada/features/more/domain/more_repo.dart';
import 'package:remontada/features/profile/domain/repositories/edit_repositories.dart';

import '../../../core/utils/utils.dart';
import '../../auth/domain/model/auth_model.dart';

class MoreCubit extends Cubit<MoreStates> {
  MoreCubit() : super(MoreInitial());
  MoreRepo moreRepo = MoreRepo(locator<DioService>());
  EditRepo editRepo = EditRepo(locator<DioService>());

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
      await Utils.dataManager.deleteUserData();
      await FBMessging.revokeToken();

      emit(LogOutSuccess());
      return true;
    } else {
      emit(LogOutFailed());
      return null;
    }
  }

  deleteAccount() async {
    emit(LogOutLoading());
    final response = await moreRepo.deleteAccount();

    if (response != null) {
      await Utils.dataManager.deleteUserData();

      emit(LogOutSuccess());
      return true;
    } else {
      emit(LogOutFailed());
      return null;
    }
  }

  getProfile() async {
    emit(ProfileLoad());
    final res = await editRepo.getProfile();
    if (res != null) {
      Utils.user = User.fromMap(res);
      if (Utils.user.user?.coaching == "pending") {
        emit(
          ProfileSuccess(coaching: "request_sent_waiting".tr()),
        );
      } else if (Utils.user.user?.coaching == "accepted") {
        emit(
          ProfileSuccess(coaching: "لقد اصبحت كابتن"),
        );
      } else if (Utils.user.user?.coaching == "refused") {
        emit(
          ProfileSuccess(coaching: "لقد تم رفض طلبك ككابتن"),
        );
      } else {
        emit(
          ProfileSuccess(coaching: ""),
        );
      }

      return true;
    } else {
      emit(ProfileFailed());
      return false;
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
    // emit(CoachLoading());
    final res = await moreRepo.coachRequest();

    if (res != null) {
      // getProfile();
      if (Utils.user.user?.coaching == "") {
        emit(ProfileSuccess(coaching: "request_sent_waiting".tr()));
      }

      return true;
    } else {
      emit(CoachFailed());
      return null;
    }
  }

  contactRequest(ContactRequest request) async {
    final res = await moreRepo.contactUs(request);
    if (res != null) {
      // emit(
      //   ProfileSuccess(coaching: "لقد تم رفض طلبك ككابتن"),
      // );
      return true;
    } else {
      return null;
    }
  }
}
