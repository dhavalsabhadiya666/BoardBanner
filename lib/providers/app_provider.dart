part of 'providers.dart';

class AppProvider extends DefaultChangeNotifier {
  final AppRepository _appRepository = GetIt.I<AppRepository>();
  List<Land> _states = [];
  List<City> _cities = [];

  Future<void> getStates() async {
    _states = await _appRepository.getStates();
    notify();
  }

  Future<void> getCities(String? stateId) async {
    _cities = await _appRepository.getCities(stateId);
    notify();
  }

  List<Land> get states => _states;

  List<City> get cities => _cities;
}
