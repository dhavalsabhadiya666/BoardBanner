import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/models/models.dart';

class NotificationRepository {
  final FirestoreCollections collections;

  NotificationRepository({required this.collections});

  Stream<List<NotificationData>> getNotifications(String? userId) {
    return collections.notificationRef
        .where(FirestoreFields.userId, isEqualTo: userId)
        .orderBy(FirestoreFields.createdAt, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationData.fromMap(doc.data());
      }).toList();
    });
  }
}
