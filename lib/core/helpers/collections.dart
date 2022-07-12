part of 'helpers.dart';

class FirestoreCollections {
  //
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection
  static const String _users = 'users';
  static const String _state = 'state';
  static const String _city = 'city';
  static const String _taskLocations = 'task_locations';
  static const String _uploadedTask = 'uploaded_task';
  static const String _notifications = 'notifications';

  CollectionReference<Map<String, dynamic>> usersRef =
      _firestore.collection(_users);

  CollectionReference<Map<String, dynamic>> stateRef =
      _firestore.collection(_state);

  CollectionReference<Map<String, dynamic>> cityRef =
      _firestore.collection(_city);

  CollectionReference<Map<String, dynamic>> taskRef =
      _firestore.collection(_taskLocations);

  CollectionReference<Map<String, dynamic>> uploadedTaskRef =
      _firestore.collection(_uploadedTask);

  CollectionReference<Map<String, dynamic>> notificationRef =
      _firestore.collection(_notifications);

  DocumentReference<Map<String, dynamic>> userDoc(String? id) {
    return usersRef.doc(id);
  }

  DocumentReference<Map<String, dynamic>> taskDoc(String? id) {
    return taskRef.doc(id);
  }

  DocumentReference<Map<String, dynamic>> uploadedTaskDoc(String? id) {
    return uploadedTaskRef.doc(id);
  }

  String get users => _users;

  String get uploadedTask => _uploadedTask;
}

class FirestoreFields {
  FirestoreFields._();

  static const String email = 'email';
  static const String deviceToken = 'deviceToken';
  static const String status = 'status';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String password = 'password';
  static const String stateId = 'state_id';
  static const String userId = 'userId';
  static const String userId2 = 'user_id';
  static const String isEnable = 'is_enable';
  static const String bankDetails = 'bankDetails';
  static const String paypalId = 'paypalId';
}
