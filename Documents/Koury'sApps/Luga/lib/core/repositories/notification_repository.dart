import '../models/notification_model.dart';

abstract class NotificationRepository {
  Stream<List<NotificationModel>> watchNotifications(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<int> getUnreadCount(String userId);
}
