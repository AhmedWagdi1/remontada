import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remontada/features/more/cubit/more_states.dart';

class MoreCubit extends Cubit<MoreStates> {
  MoreCubit() : super(MoreInitial());
  static MoreCubit get(context) => BlocProvider.of(context);
  Future<bool?> checkNotificationEnabled() async {
    var androidPlugin = FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    bool? notificationEnabled = await androidPlugin?.areNotificationsEnabled();

    return notificationEnabled;
  }
}
