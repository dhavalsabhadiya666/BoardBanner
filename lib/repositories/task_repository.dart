import 'dart:io';

import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/models/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class TaskRepository {
  final FirestoreCollections collections;
  TaskRepository({required this.collections});

  Stream<List<TaskLocation>> getTaskLocations(String? userId) {
    return Rx.combineLatest2(
      _taskLocationStream(),
      acceptedTaskLocationStream(userId),
      (List<TaskLocation> tasks, List<TaskLocation> acceptedTasks) {
        return [tasks, acceptedTasks].expand((e) => e).toList();
      },
    );
  }

  Stream<List<TaskLocation>> _taskLocationStream() {
    return collections.taskRef
        .where(FirestoreFields.status, isEqualTo: 0)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskLocation.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<TaskLocation>> acceptedTaskLocationStream(String? userId) {
    return collections.taskRef
        .where(FirestoreFields.userId, isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskLocation.fromMap(doc.data());
      }).toList();
    });
  }

  Future<void> acceptTask(
      {required String? taskLocationId, required String? userId}) {
    return collections.taskDoc(taskLocationId).update(
      {FirestoreFields.userId: userId, FirestoreFields.status: 1},
    );
  }

  Future<void> updateTaskLocationField({
    required String? taskLocationId,
    required String fieldName,
    required dynamic value,
  }) {
    return collections.taskDoc(taskLocationId).update({
      fieldName: value,
      FirestoreFields.updatedAt: DateTime.now(),
    });
  }

  Future<void> uploadTask(UploadedTask uploadedTask, File file) async {
    uploadedTask.uploadedTaskId = const Uuid().v4();
    uploadedTask.addedOn = DateTime.now();
    uploadedTask.videoUrl = await uploadTaskVideo(file);
    return collections
        .uploadedTaskDoc(uploadedTask.uploadedTaskId)
        .set(uploadedTask.toMap());
  }

  Future<String?> uploadTaskVideo(File file) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child(collections.uploadedTask)
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    return await reference.putFile(file).then((snapshot) async {
      return await snapshot.ref.getDownloadURL();
    });
  }

  Stream<List<TaskLocation>> getMyTaksLocations(String? userId) {
    return Rx.combineLatest2(
      acceptedTaskLocationStream(userId),
      getUploadedTask(userId),
      (List<TaskLocation> acceptedTasks, List<UploadedTask> uploadedTasks) {
        return acceptedTasks.map((task) {
          var _uploadedTasks = uploadedTasks
              .where((element) => element.taskLocationId == task.taskLocationId)
              .toList();

          if (_uploadedTasks.isNotEmpty) {
            task.uploadedTaskStatus = _uploadedTasks.first.status ?? 0;
            task.accepetedRejectedDate =
                _uploadedTasks.first.acceptRejectedDate;
          }

          return task;
        }).toList();
      },
    );
  }

  Stream<List<UploadedTask>> getUploadedTask(String? userId) {
    return collections.uploadedTaskRef
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) => UploadedTask.fromMap(e.data())).toList();
    });
  }
}
