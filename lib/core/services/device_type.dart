import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:remontada/core/utils/utils.dart';

class Device {
  static DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static getDeviceType() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    // var deviceData;

    try {
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfoPlugin.androidInfo;
        Utils.deviceType = 'Android Device: ${androidInfo.model}';
        Utils.uuid = androidInfo.id;
        log(Utils.deviceType ?? "ashraf");
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfoPlugin.iosInfo;
        Utils.deviceType = 'iOS Device: ${iosInfo.utsname.machine}';
        Utils.uuid = iosInfo.identifierForVendor ?? "";
      } else {
        Utils.deviceType = 'Unknown Device';
      }
    } catch (e) {
      Utils.deviceType = 'Failed to get device info: $e';
    }

    // setState(() {
    //   deviceInfo = deviceData;
    // });
  }
}
