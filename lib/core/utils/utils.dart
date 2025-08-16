import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:remontada/core/utils/firebase_message.dart';
import 'package:remontada/features/auth/domain/model/auth_model.dart';

import '../data_source/hive_helper.dart';
import 'Locator.dart';
import 'validations.dart';

class Utils {
  static String token = '';
  static String appVersion = '';

  static String lang = '';
  static String FCMToken = '';
  static String userType = "";
  static String deviceType = "";
  static String uuid = "";
  static String lat = "";
  static String lng = "";
  static bool? isSuperVisor = false;

  static User user = User();
  static bool fromNotification = false;

  static String get userId => user.user?.id?.toString() ?? '';

  // static UserModel userModel = UserModel();
  static GlobalKey<NavigatorState> navigatorKey() =>
      locator<GlobalKey<NavigatorState>>();
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static Validation get valid => locator<Validation>();
  static DataManager get dataManager => locator<DataManager>();

  static saveUserInHive(Map<String, dynamic> response) async {
    // user = User.fromMap(response);

    user = User.fromMap(response);
    token = user.token ?? '';
    isSuperVisor = user.user?.type == "supervisor";
    FBMessging.subscripeAllUsers();
    await user.type == "client"
        ? FBMessging.subscripeAllclients()
        : FBMessging.subscripeAllcouches();
    await Utils.dataManager.saveUser(Map<String, dynamic>.from(response));
  }

  static deleteUserData() async {
    token = '';
    FCMToken = "";
    isSuperVisor = false;
    await Future.wait([
      dataManager.deleteUserData(),
      FBMessging.subscripeAllUsers(),
      user.type == "client"
          ? FBMessging.subscripeAllclients()
          : FBMessging.subscripeAllcouches()
    ]);
    user = User();
  }

  static void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  static void fixRtlLastChar(TextEditingController? controller) {
    if (controller != null) {
      if (controller.selection ==
          TextSelection.fromPosition(
              TextPosition(offset: (controller.text.length) - 1))) {
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
      }
    }
  }

  static genrateBarcode() {
    return (Random().nextInt(99999999) + 10000000).toString();
  }

  static double getSizeOfFile(File file) {
    final size = file.readAsBytesSync().lengthInBytes;
    final kb = size / 1024;
    final mb = kb / 1024;
    print(mb);
    return mb;
  }
}

extension MySLiverBox on Widget {
  // SliverToBoxAdapter get SliverBox => SliverToBoxAdapter(
  //   child: this,
  // );
  /*  SliverToBoxAdapter get SliverBoxAnimation => SliverToBoxAdapter(
    child: Padding(
      padding:  EdgeInsets.all(16),
      child: this,
    ),
  ); */
}
