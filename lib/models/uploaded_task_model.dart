part of 'models.dart';

class UploadedTask {
  String? uploadedTaskId;
  String? userId;
  String? billBoardCompanyId;
  String? taskLocationId;
  DateTime? addedOn;
  DateTime? acceptRejectedDate;
  String? videoUrl;
  int? status;

  /// Form [TaskLocation] to [UploadedTask]
  String? name;
  String? description;
  String? image;
  int? taskLocationStatus;
  num? rewardAmount;

  UploadedTask({
    this.uploadedTaskId,
    this.userId,
    this.billBoardCompanyId,
    this.taskLocationId,
    this.addedOn,
    this.acceptRejectedDate,
    this.videoUrl,
    this.status,
    this.name,
    this.image,
    this.taskLocationStatus,
    this.rewardAmount,
  });

  factory UploadedTask.fromMap(Map<String, dynamic> data) {
    return UploadedTask(
      uploadedTaskId: data['uploaded_task_id'],
      userId: data['user_id'],
      billBoardCompanyId: data['bill_board_company_id'],
      taskLocationId: data['task_location_id'],
      addedOn: DateTime.fromMillisecondsSinceEpoch(int.parse(data['added_on'])),
      acceptRejectedDate: data['accepted_rejected_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.parse(data['accepted_rejected_date']))
          : null,
      videoUrl: data['video_url'],
      status: data['status'],
    );
  }

  Color backgroundColor() {
    switch (status) {
      case 1:
        return const Color(0xffF5FBF6);
      case 2:
        return const Color(0xffFEF7F6);
      default:
    }
    return Colors.white;
  }

  Color statusColor() {
    switch (status) {
      case 1:
        return AppColors.primary;
      case 2:
        return Colors.red;
      default:
    }
    return Colors.white;
  }

  Map<String, dynamic> toMap() {
    return {
      'uploaded_task_id': uploadedTaskId,
      'user_id': userId,
      'bill_board_company_id': billBoardCompanyId,
      'task_location_id': taskLocationId,
      'added_on': addedOn?.millisecondsSinceEpoch.toString(),
      'accepted_rejected_date':
          acceptRejectedDate?.millisecondsSinceEpoch.toString(),
      'video_url': videoUrl,
      'status': status,
    };
  }
}
