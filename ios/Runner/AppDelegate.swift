import UIKit
import Flutter
import GoogleMaps
import Firebase
import flutter_local_notifications
import app_links

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

        GMSServices.provideAPIKey("AIzaSyAD25N22diVc_aNlpdm34JnGd8aZV08ZhM")

     FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
    } else {
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    application.registerForRemoteNotifications()
      if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
      // We have a link, propagate it to your Flutter app or not
      AppLinks.shared.handleLink(url: url)
      return true // Returning true will stop the propagation to other packages
    }
  
    application.registerForRemoteNotifications()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
