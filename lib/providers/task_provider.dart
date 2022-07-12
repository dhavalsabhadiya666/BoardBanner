part of 'providers.dart';

class TaskProvider extends DefaultChangeNotifier {
  TaskLocation? _taskLocation;
  RunningTaskStatus _taskStatus = RunningTaskStatus.none;
  Distance? _distance;

  final TaskRepository _taskRepository = GetIt.I<TaskRepository>();
  final LocationRepository _locationRepository = GetIt.I<LocationRepository>();

  LatLng? _currentLatLng;

  bool _isMapView = true;

  Future<void> getCurrentLocation() async {
    try {
      setLoading(true);
      LocationResult result = await LocationService.getCurrentLocation();
      if (result.status) {
        if (result.latitude != null && result.longitude != null) {
          _currentLatLng =
              LatLng(result.latitude ?? 0.0, result.longitude ?? 0.0);
          notify();
          log(_currentLatLng.toString());
        }
      } else {
        setLoading(false);
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> acceptTask(
      {required String? taskLocationId, required String? userId}) async {
    try {
      setLoading(true);
      return await _taskRepository.acceptTask(
        taskLocationId: taskLocationId,
        userId: userId,
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> uploadTask({
    required BuildContext context,
    required String? userId,
    required File file,
  }) async {
    try {
      Loader.show(context);
      UploadedTask uploadedTask = UploadedTask();
      uploadedTask.userId = userId;
      uploadedTask.billBoardCompanyId = _taskLocation?.billBoardCompanyId;
      uploadedTask.taskLocationId = _taskLocation?.taskLocationId;
      uploadedTask.status = 0;
      return await _taskRepository
          .uploadTask(uploadedTask, file)
          .whenComplete(() {
        _taskRepository.updateTaskLocationField(
          taskLocationId: _taskLocation?.taskLocationId,
          fieldName: FirestoreFields.status,
          value: 2,
        );
      });
    } finally {
      Loader.dismiss(context);
    }
  }

  Future<void> getDistance() async {
    _distance = await _locationRepository.getDistance(
      start: currentPointLatLng,
      end: taskPointLatLng,
    );
    notify();
  }

  double getDistanceInMetres() {
    return Geolocator.distanceBetween(
      _currentLatLng?.latitude ?? 0.0,
      _currentLatLng?.longitude ?? 0.0,
      _taskLocation?.lat ?? 0.0,
      _taskLocation?.long ?? 0.0,
    );
  }

  void setTaskLocation(TaskLocation? value) {
    _taskLocation = value;
    notify();
  }

  void onChangeMapView(bool value) {
    _isMapView = value;
    notify();
  }

  void onChangeTaskStatus(RunningTaskStatus value) {
    _taskStatus = value;
    notify();
  }

  void setCurrentLocation(LatLng value) {
    _currentLatLng = value;
    notify();
  }

  PointLatLng get currentPointLatLng {
    return PointLatLng(
        _currentLatLng?.latitude ?? 0.0, _currentLatLng?.longitude ?? 0.0);
  }

  PointLatLng get taskPointLatLng {
    return PointLatLng(taskLocation?.lat ?? 0.0, _taskLocation?.long ?? 0.0);
  }

  List<LatLng> get polylineLatLngs {
    return _currentLatLng != null && _taskLocation != null
        ? [
            _currentLatLng ?? const LatLng(0.0, 0.0),
            LatLng(_taskLocation?.lat ?? 0.0, _taskLocation?.long ?? 0.0)
          ]
        : <LatLng>[];
  }

  bool get isMapView => _isMapView;

  RunningTaskStatus get taskStatus => _taskStatus;

  LatLng? get currentLatLng => _currentLatLng;

  TaskLocation? get taskLocation => _taskLocation;

  Distance? get distance => _distance;
}
