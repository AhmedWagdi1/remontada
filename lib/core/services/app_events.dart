import 'package:flutter/foundation.dart';

/// Small app-level event hub for simple cross-widget notifications.
/// Currently used to notify matches listing screens to refresh after a create/delete.
class AppEvents {
  /// Increment this value to request matches refresh across the app.
  static final ValueNotifier<int> matchesRefresh = ValueNotifier<int>(0);
}
