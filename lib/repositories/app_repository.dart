import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/models/models.dart';

class AppRepository {
  final FirestoreCollections collections;

  AppRepository({required this.collections});

  Future<List<Land>> getStates() {
    return collections.stateRef.get().then((snap) {
      return snap.docs.map((e) => Land.fromMap(e.data())).toList();
    });
  }

  Future<List<City>> getCities(String? stateId) {
    return collections.cityRef
        .where(FirestoreFields.stateId, isEqualTo: stateId)
        .get()
        .then((snap) {
      return snap.docs.map((e) => City.fromMap(e.data())).toList();
    });
  }
}
