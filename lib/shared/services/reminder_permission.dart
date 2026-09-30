import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Asks the operating system for permission to show reminders.
abstract interface class ReminderPermission {
  /// True if reminders may be shown.
  Future<bool> request();
}

class LocalNotificationsPermission implements ReminderPermission {
  final _plugin = FlutterLocalNotificationsPlugin();

  @override
  Future<bool> request() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? false;
  }
}

final reminderPermissionProvider = Provider<ReminderPermission>((ref) => LocalNotificationsPermission());
