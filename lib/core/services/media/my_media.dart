import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../shared/widgets/button_widget.dart';
import '../../../shared/widgets/customtext.dart';
import '../../utils/utils.dart';

class MyMedia {
  static final ImagePicker _picker = ImagePicker();

  static Future<List<File>?> pickImages({bool isMultiple = true}) async {
    List<XFile?>? images = [];

    try {
      if (isMultiple) {
        images = await _picker.pickMultiImage();
      } else {
        images = [
          await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 100,
            maxWidth: 1080,
          )
        ];
      }
      List<File>? imageFiles =
          images.map<File>((xfile) => File(xfile?.path ?? "")).toList();
      return imageFiles.isNotEmpty ? imageFiles : null;
    } catch (e) {
      print(e);
      final check = await handelPermission();
      if (check != true) return null;
      if (isMultiple) {
        images = await _picker.pickMultiImage();
      } else {
        images = [
          await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 100,
            maxWidth: 1080,
          )
        ];
      }
      List<File>? imageFiles =
          images.map<File>((xfile) => File(xfile?.path ?? "")).toList();
      return imageFiles.isNotEmpty ? imageFiles : null;
    }

    // final check = await handelPemission();
    // if (check != true) return null;
    // if (isMultiple) {
    //   images = await _picker.pickMultiImage();
    // } else {
    //   images = [
    //     await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100, maxWidth:1080,maxHight:1920,)
    //   ];
    // }
    // List<File>? imageFiles =
    //     images.map<File>((xfile) => File(xfile?.path ?? "")).toList();
    // return imageFiles.isNotEmpty ? imageFiles : null;
  }

  static Future<File?> pickImageFromGallery() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 1080,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      print(e);
      final check = await handelPermission();
      if (check != true) return null;
      final image = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 100, maxWidth: 1080);
      return image != null ? File(image.path) : null;
    }
  }

  static Future<File?> pickImageFromCamera() async {
    try {
      final image = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 100, maxWidth: 1080);
      return image != null ? File(image.path) : null;
    } catch (e) {
      print(e);
      final check = await handelCameraPermission();
      if (check != true) return null;
      final image = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 100, maxWidth: 1080);
      return image != null ? File(image.path) : null;
    }
    // final check = await handelCameraPermission();
    // if (check != true) return null;
    // final image =
    //     await _picker.pickImage(source: ImageSource.camera, imageQuality: 100, maxWidth:1080,maxHight:1920,);
    // return image != null ? File(image.path) : null;
  }

  static handelPermission() async {
    late PermissionStatus status;
    late AndroidDeviceInfo androidInfo;
    if (Platform.isAndroid) {
      androidInfo = await DeviceInfoPlugin().androidInfo;
    }

    if (Platform.isAndroid && androidInfo.version.sdkInt <= 32) {
      /// use [Permissions.storage.status]
      status = await Permission.storage.request();
    } else {
      status = await Permission.photos.request();
    }
    if (status.isDenied || status.isPermanentlyDenied) {
      await openSettingPermissionDialog();
    } else {
      return true;
    }
  }

  static handelCameraPermission() async {
    late PermissionStatus status;

    status = await Permission.camera.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      await openSettingPermissionDialog();
    } else {
      return true;
    }
  }

  static Future<dynamic> openSettingPermissionDialog() {
    return showDialog(
        context: Utils.navigatorKey().currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: CustomText('Permission'.tr()),
            content: CustomText(
                'Please enable camera permission from app settings'.tr()),
            actions: [
              TextButtonWidget(
                function: () => Navigator.of(context).pop(),
                text: 'Cancel'.tr(),
              ),
              TextButtonWidget(
                function: () => openAppSettings()
                    .then((value) => Navigator.of(context).pop()),
                text: 'Settings'.tr(),
              ),
            ],
          );
        });
  }
}
