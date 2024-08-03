import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_uuid/device_uuid.dart';
import 'package:remontada/core/utils/utils.dart';

class Device {
  static DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static getDeviceType() async {
    // DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    // var deviceData;

    try {
      if (Platform.isAndroid) {
        Utils.deviceType = 'android';
      } else if (Platform.isIOS) {
        Utils.deviceType = 'ios';
      } else {
        Utils.deviceType = 'Unknown Device';
      }
      Utils.uuid = await DeviceUuid().getUUID() ?? "";
      log(Utils.uuid);
    } catch (e) {
      Utils.deviceType = 'Failed to get device info: $e';
    }

    // setState(() {
    //   deviceInfo = deviceData;
    // });
  }
}
