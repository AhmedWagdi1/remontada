import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:developer';

class FireBaseRemoteService {
  static FirebaseRemoteConfig? remoteConfig;

  static Future<void> intializeRemoteConfig() async {
    try {
      remoteConfig = FirebaseRemoteConfig.instance;

      // Set more reasonable config settings
      RemoteConfigSettings remoteConfigSettings = RemoteConfigSettings(
        fetchTimeout:
            Duration(minutes: 1), // Increased from 1 second to 1 minute
        minimumFetchInterval:
            Duration(hours: 1), // Increased from 1 second to 1 hour
      );

      await remoteConfig!.setConfigSettings(remoteConfigSettings);

      // Set default values first
      await remoteConfig!.setDefaults({
        // Add your default values here if needed
      });

      // Try to fetch and activate
      bool activated = await remoteConfig!.fetchAndActivate();

      if (activated) {
        log('Firebase Remote Config activated successfully');
      } else {
        log('Firebase Remote Config fetch completed but no updates were activated');
      }
    } catch (e) {
      log('Error initializing Firebase Remote Config: $e');
      // Initialize with defaults on error
      try {
        remoteConfig = FirebaseRemoteConfig.instance;
        await remoteConfig!.setDefaults({});
      } catch (defaultError) {
        log('Failed to set default Remote Config values: $defaultError');
      }
    }
  }

  static String getString(String key) {
    try {
      if (remoteConfig == null) {
        log('Remote Config not initialized, returning empty string for key: $key');
        return '';
      }
      return remoteConfig!.getString(key);
    } catch (e) {
      log('Error getting Remote Config value for key $key: $e');
      return '';
    }
  }
}
