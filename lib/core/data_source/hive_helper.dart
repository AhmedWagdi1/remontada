import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

// import '../../modules/auth/domain/model/auth_model.dart';
import '../utils/utils.dart';

class DataManager {
  late BoxCollection collection;
  late Box userData;
  late Box deviceToken;

  static const devicetoken = "devicetoken";
  static const USER = "USER";

  Future initHive() async {
    await Hive.initFlutter();
    userData = await Hive.openBox('dataUser');
    deviceToken = await Hive.openBox("deviceToken");
    // final directory = await getApplicationDocumentsDirectory();
    // collection = await BoxCollection.open(
    //   'dataManager', // Name of your database
    //   {'data'}, // Names of your boxes
    //   path: directory
    //       .path, // Path where to store your boxes (Only used in Flutter / Dart IO)
    // );
  }

  Future<void> saveData(String key, dynamic value) async {
    final box = await Hive.openBox('data');
    await box.put(key, value);
    box.close();
  }

  Future saveDeviceToken(String value) async {
    await deviceToken.put(devicetoken, value);
    // log("success save");
  }

  saveUser(Map<String, dynamic> value) async {
    // await Hive.initFlutter();
    // final userData = await Hive.openBox('dataUser');
    await userData.put(USER, value);
    // userData.close();
  }

  getData(String key) async {
    // await Hive.initFlutter();
    final box = await Hive.openBox('data');

    return box.get(key);
  }

  getUserData() async {
    // final userData = await Hive.openBox('dataUser');

    try {
      final user = (Map<String, dynamic>.from(userData.get(USER)));

      Utils.token = user['access_token'];
      Utils.isSuperVisor = user['type'] == "supervisor";
      log(Utils.token);

      // Utils.userModel = UserModel.fromJson(Map<String, dynamic>.from(user));

      return userData.get(USER);
    } catch (e) {
      log(e.toString());
      //  userData.clear();
    }
  }

  Future deleteUserData() async {
    // final userData = await Hive.openBox('dataUser');
    // userData = await Hive.openBox(USER);
    return await userData.delete(USER);
  }

  deleteAllData() async {
    final userData = await Hive.openBox('data');

    return userData.delete(USER);
  }
}
