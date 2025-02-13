import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/core/utils/firebase_message.dart';
import 'package:remontada/features/more/cubit/more_states.dart';
import 'package:remontada/features/more/domain/contact_request.dart';
import 'package:remontada/features/more/domain/model/model.dart';
import 'package:remontada/features/more/domain/more_repo.dart';
import 'package:remontada/features/profile/domain/repositories/edit_repositories.dart';

import '../../../core/theme/light_theme.dart';
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

  getLocatiionPermissionStatus() async {
    PermissionStatus status = await Permission.location.status;
    return status == PermissionStatus.granted;
  }

  Future<Position?> getLocation() async {
    try {
      PermissionStatus status = await Permission.location.status;
      await Permission.location.request;
      // Permission.location.onDeniedCallback(() async {
      //   await Permission.location.request();
      // });
      if (status.isDenied == true) {
        await Permission.location.request();

        // showLocationPermissionDialog(
        //   context,
        // );
        emit(LocationDeniedstate());
      } else if (status.isPermanentlyDenied == true) {
        // await Permission.location.request();
        // showLocationPermissionDialog(
        //   context,
        // );
        emit(LocationDeniedstate());
      } else if (status.isGranted == true) {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }
    } catch (e) {
      log(e.toString(), name: "error");
    }
    // print("status $status");
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getPostion() async {
    Position? position = await getLocation();

    Utils.lng = position?.longitude.toString() ?? "";
    Utils.lat = position?.latitude.toString() ?? "";
    log(Utils.lng);
    log(Utils.lat);
    emit(LocationAcceptedState());
  }

  void showLocationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "location_req".tr(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'location_req1'.tr() + 'location_req2'.tr() + 'location_req3'.tr(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'settings.cancel'.tr(),
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: LightThemeColors.primary, // لون الزر
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('openSetting'.tr()),
              onPressed: () async {
                Platform.isAndroid
                    ? await Geolocator.openAppSettings()
                    : await Geolocator
                        .openLocationSettings(); // يفتح إعدادات التطبيق
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  logOut() async {
    emit(LogOutLoading());
    final response = await moreRepo.logout();

    if (response != null) {
      Utils.deleteUserData();
      FBMessging.revokeToken();

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
