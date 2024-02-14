import 'package:todo_app/app/global/global.dart';
import 'package:todo_app/app/notification/configs/notifications_config.dart';
import 'package:todo_app/app/notification/repositories/group_notifications_repo.dart';
import 'package:todo_app/app/notification/repositories/local_notifications_repo.dart';
import 'package:todo_app/app/notification/repositories/platforms_notificatoin_repo.dart';
import 'package:todo_app/app/services/local_notifications_service.dart';

Future<void> initAppModules() async {
  // App module, its a module where we put all generic dependencies

  const _notificationConfig = NotificationConfigImpl.instance;

  await _notificationConfig.initialize();

  Global.getIt.registerLazySingleton<NotificationConfig>(
    () => _notificationConfig,
  );

  Global.getIt.registerLazySingleton<PlatformsNotification>(
    () => PlatformsNotificationImpl(),
  );

  Global.getIt.registerLazySingleton<GroupNotifications>(
    () => GroupNotificationsImpl(),
  );

  Global.getIt.registerLazySingleton<LocalNotification>(
    () => LocalNotificationImpl(Global.getIt(), Global.getIt(), Global.getIt()),
  );

  Global.getIt.registerLazySingleton<LocalNotificationsService>(
    () => LocalNotificationsServiceImpl(Global.getIt()),
  );
}
