import 'package:url_launcher/url_launcher.dart';
// import 'package:whatsapp/whatsapp.dart';

class LauncherHelper {
  static openNotificationsettings() async {
    // URL intent for Android settings
    const String url = 'app-settings';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
  // static openUrl(String url, {LaunchMode mode = LaunchMode.platformDefault}) {
  //   final urlParse = Uri.parse(url);
  //   launchUrl(urlParse);
  // }

  // WhatsApp whatsapp = WhatsApp();

  // //wa
  // static openWhatsApp(String phone,
  //     {LaunchMode mode = LaunchMode.platformDefault}) async {
  //   print(phone);
  //   var whatsappUrl = Uri.parse("https://api.whatsapp.com/send?phone=$phone");
  //   print(whatsappUrl);
  //   await canLaunchUrl(whatsappUrl)
  //       ? launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)
  //       : print(
  //           "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  // }

  // static void openGoogleMaps(double latitude, double longitude) async {
  //   Uri googleMapsUrl = Uri.parse(
  //       'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

  //   if (await canLaunchUrl(googleMapsUrl)) {
  //     await launchUrl(googleMapsUrl);
  //   } else {
  //     throw 'Could not open the map.';
  //   }
  // }
}
