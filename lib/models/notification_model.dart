part of 'models.dart';

class NotificationData {
  String? notificationId;
  NotificationType? type;
  String? userId;
  String? title;
  String? content;
  DateTime? createdAt;

  NotificationData({
    this.notificationId,
    this.type,
    this.userId,
    this.title,
    this.content,
    this.createdAt,
  });

  factory NotificationData.fromMap(Map<String, dynamic> data) {
    return NotificationData(
      notificationId: data['notificationId'],
      type: notificationTypeMap[data['type']],
      userId: data['userId'],
      title: data['title'],
      content: data['content'],
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(int.parse(data['createdAt'])),
    );
  }

  String getDate() {
    return DateFormat('dd MMM yyyy').format(createdAt ?? DateTime(1990));
  }

  String getTime() {
    return DateFormat('hh:mm a').format(createdAt ?? DateTime(1990));
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'type': type?.index,
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': createdAt?.millisecondsSinceEpoch.toString(),
    };
  }
}
