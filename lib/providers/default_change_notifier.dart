part of 'providers.dart';

abstract class DefaultChangeNotifier extends ChangeNotifier {
  bool _loading = false;

  void setLoading(bool status) {
    _loading = status;
    notify();
  }

  void notify() {
    notifyListeners();
  }

  bool get loading => _loading;
}
