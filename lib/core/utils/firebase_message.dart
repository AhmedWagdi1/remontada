import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/firebase_options.dart';

import '../../features/notifications/domain/model/notify_model.dart';

class FBMessging {
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    print(Utils.FCMToken);
  }

  static Future<void> enableIosNotify() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // static Future<void> onbackGroundMessageHandler(RemoteMessage message) async {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   enableIosNotify();
  // }

  static AndroidNotificationChannel androidChannel() {
    return const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
  }

  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static Future<void> initUniLink() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    
    // Request permissions with error handling
    try {
      await messaging.requestPermission(
        alert: true,
        announcement: false,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        badge: true,
        provisional: false,
      );
    } catch (e) {
      print('Error requesting notification permissions: $e');
      // Continue without permissions - user can grant them later
    }

    AndroidNotificationChannel channel = androidChannel();
    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    AndroidInitializationSettings androidsettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings iosSetting =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentSound: true,
    );
    InitializationSettings settings = InitializationSettings(
      iOS: iosSetting,
      android: androidsettings,
    );

    plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        log(response.payload ?? "aaaaaaaa");
        NotificationModel notification =
            NotificationModel.fromJson(response.payload ?? "");
        // handleNotification(
        //   notification,
        //   appIsopened: true,
        // );
      },
    );

    FirebaseMessaging.onMessage.listen((event) {
      log('onMessage222');
      log("$event");
      log("${event.data}");
      log("${event.notification}");

      log("${event.notification}");
      log('${event.data}');
      log('${event.data}');

      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      AppleNotification? appl = event.notification?.apple;
      NotificationModel notificationModel =
          NotificationModel.fromMap(event.data);
      // log('${notificationModel.modelId}', name: "notificationModel.modelId");
      // // log(Utils.room_id, name: " Utils.room_id");
      // log((notificationModel.modelId != Utils.room_id).toString(),
      //     name: 'notificationModel.modelId != Utils.room_id');
      // log((RouteGenerator.currentRoute != Routes.ChatScreen).toString(),
      //     name: 'RouteGenerator.currentRoute != Routes.ChatScreen');
      // if ((notificationModel.modelId != Utils.room_id ||
      //         notificationModel.modelType == "global") &&
      //     RouteGenerator.currentRoute != Routes.ChatScreen) {
      if (notificationModel.type == "client" ||
          notificationModel.type == "supervisor") {
        // locator<SplashRepository>().getProfileData();
        Navigator.pushNamed(
          Utils.navigatorKey().currentContext!,
          Routes.splashScreen,
        );
      }
      plugin.show(
        payload: notificationModel.toJson(),
        notification.hashCode,
        notification?.title,
        notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    }
        // },
        );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        log('onMessageOpenedApp no 666');
        log(message.toString());
        log(message.data.toString());
        NotificationModel notification =
            NotificationModel.fromMap(message.data);
        // handleNotification(
        //   notification,
        //   appIsopened: false,
        // );

        ///6
      },
    );

    ///If the application has been opened from a terminated state via a [RemoteMessage] (containing a [Notification]), it will be returned, otherwise it will be null.

    messaging.getInitialMessage().then(
      (message) {
        // print('getInitialMessage');

        ///5
        log('getInitialMessage no 55');
        log(message.toString());
        print(message?.data.toString());
        if (message != null) {
          NotificationModel notification =
              NotificationModel.fromMap(message.data);
          // handleNotification(
          //   notification,
          //   appIsopened: false,
          // );
          log('getInitialMessage no 55');
          log(message.toString());
          log(message.data.toString());
        }
      },
    );
    await getToken();
  }

  // static handleNotification(NotificationModel notification,
  //     {bool appIsopened = false}) {
  //   if (notification.modelType == "chat") {
  //     if (appIsopened) {
  //       if (RouteGenerator.currentRoute == Routes.ChatScreen) {
  //         Utils.room_id = "";
  //         Navigator.pop(Utils.navigatorKey().currentState!.context);
  //         Future.delayed(
  //           const Duration(
  //             milliseconds: 500,
  //           ),
  //           () => Navigator.pushNamed(
  //             Utils.navigatorKey().currentContext!,
  //             Routes.ChatScreen,
  //             arguments: notification.modelId,
  //           ),
  //         );
  //       } else {
  //         Navigator.pushNamed(
  //           Utils.navigatorKey().currentContext!,
  //           Routes.ChatScreen,
  //           arguments: notification.modelId,
  //         );
  //       }
  //     } else {
  //       Navigator.pushNamed(
  //         Utils.navigatorKey().currentContext!,
  //         Routes.LayoutScreen,
  //       );
  //       Navigator.pushNamed(
  //         Utils.navigatorKey().currentContext!,
  //         Routes.ChatScreen,
  //         arguments: notification.modelId,
  //       );
  //     }
  //   } else if (notification.modelType == "item") {
  //     if (appIsopened) {
  //       if (RouteGenerator.currentRoute == Routes.ProductDetailsScreen) {
  //         Navigator.pop(Utils.navigatorKey().currentContext!);
  //         Navigator.pushNamed(
  //           Utils.navigatorKey().currentContext!,
  //           Routes.ProductDetailsScreen,
  //           arguments: notification.modelId,
  //         );
  //       } else {
  //         Navigator.pushNamed(
  //           Utils.navigatorKey().currentContext!,
  //           Routes.ProductDetailsScreen,
  //           arguments: notification.modelId,
  //         );
  //       }
  //     } else {
  //       Navigator.pushNamed(
  //         Utils.navigatorKey().currentContext!,
  //         Routes.ProductDetailsScreen,
  //         arguments: notification.modelId,
  //       );
  //     }
  //   } else if (notification.modelType == "user") {
  //     if (appIsopened) {
  //       if (RouteGenerator.currentRoute == Routes.FollowersDetailsScreen) {
  //         Navigator.pop(Utils.navigatorKey().currentContext!);
  //         Navigator.pushNamed(Utils.navigatorKey().currentContext!,
  //             Routes.FollowersDetailsScreen,
  //             arguments: FollowerArgs(
  //               id: notification.modelId ?? "",
  //             ));
  //       } else {
  //         Navigator.pushNamed(Utils.navigatorKey().currentContext!,
  //             Routes.FollowersDetailsScreen,
  //             arguments: FollowerArgs(
  //               id: notification.modelId ?? "",
  //             ));
  //       }
  //     } else {
  //       Navigator.pushNamed(
  //           Utils.navigatorKey().currentContext!, Routes.FollowersDetailsScreen,
  //           arguments: FollowerArgs(
  //             id: notification.modelId ?? "",
  //           ));
  //     }
  //   }
  // }

  static getToken() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      
      // Wait for Firebase to be fully initialized
      await Future.delayed(const Duration(seconds: 2));
      
      // Check if messaging is available
      if (messaging != null) {
        final tokenFcm = await messaging.getToken();
        print('FCM Token: $tokenFcm');
        Utils.FCMToken = tokenFcm ?? '';
      } else {
        print('Firebase Messaging not available');
        Utils.FCMToken = '';
      }
    } catch (e) {
      print('Error getting FCM token: $e');
      Utils.FCMToken = '';
      // Don't rethrow - allow app to continue without FCM
    }
  }

  static Future revokeToken() async {
    await messaging.deleteToken();
  }

  // subscripe to topic all users
  static Future subscripeAllUsers() async {
    await messaging.subscribeToTopic("all_users");
  }

  static Future unSubscripeAllUsers() async {
    await messaging.unsubscribeFromTopic("all_users");
  }

  // subscripe to topic all users
  static Future subscripeAllclients() async {
    await messaging.subscribeToTopic("all_clients");
  }

  static Future unSubscripeAllclients() async {
    await messaging.unsubscribeFromTopic("all_clients");
  }

  // subscripe to topic all users
  static Future subscripeAllcouches() async {
    await messaging.subscribeToTopic("all_couches");
  }

  static Future unSubscripeAllcouches() async {
    await messaging.unsubscribeFromTopic("all_couches");
  }
}
