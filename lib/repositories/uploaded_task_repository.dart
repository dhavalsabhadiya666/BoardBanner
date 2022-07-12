import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/repositories/task_repository.dart';
import 'package:rxdart/rxdart.dart';

class UploadedTaskRepository {
  final FirestoreCollections collections;
  final TaskRepository taskRepository;

  UploadedTaskRepository(
      {required this.collections, required this.taskRepository});

  Stream<List<UploadedTask>> getUploadedTasks(String? userId) {
    return Rx.combineLatest2(
      _getUploadedTasks(userId),
      taskRepository.acceptedTaskLocationStream(userId),
      (List<UploadedTask> uploadedTasks, List<TaskLocation> taskLocations) {
        return uploadedTasks.map((uploadedTask) {
          var taskLocationValues = taskLocations
              .where((taskLocation) =>
                  taskLocation.taskLocationId == uploadedTask.taskLocationId)
              .toList();

          if (taskLocationValues.isNotEmpty) {
            uploadedTask.name = taskLocationValues.first.billBoardName;
            uploadedTask.image = taskLocationValues.first.billboardImage;
            uploadedTask.description =
                taskLocationValues.first.locationDescription;
            uploadedTask.taskLocationStatus = taskLocationValues.first.status;
            uploadedTask.rewardAmount = taskLocationValues.first.rewardAmount;
          }
          return uploadedTask;
        }).toList();
      },
    );
  }

  Stream<List<UploadedTask>> _getUploadedTasks(String? userId) {
    return collections.uploadedTaskRef
        .where(FirestoreFields.userId2, isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UploadedTask.fromMap(doc.data());
      }).toList();
    });
  }
}
