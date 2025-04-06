import 'package:firebase_remote_config/firebase_remote_config.dart';

class FireBaseRemoteService {
  static late FirebaseRemoteConfig remoteConfig;

  static intializeRemoteConfig() async {
    remoteConfig = FirebaseRemoteConfig.instance;
    RemoteConfigSettings remoteConfigSettings = RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 1),
      minimumFetchInterval: Duration(
        seconds: 1,
      ),
    );
    remoteConfig.setConfigSettings(remoteConfigSettings);
    await remoteConfig.fetchAndActivate().then(
      (val) {
        if (val) {
          return;
        } else {
          remoteConfig.setDefaults(
            {},
          );
        }
      },
    );
  }

  static String getString(String key) => remoteConfig.getString(key);
}
