part of 'explore.dart';

class TaskMapView extends StatefulWidget {
  final List<TaskLocation> taskLocations;
  const TaskMapView(this.taskLocations, {Key? key}) : super(key: key);

  @override
  State<TaskMapView> createState() => _TaskMapViewState();
}

class _TaskMapViewState extends State<TaskMapView> {
  //
  GoogleMapController? _googleMapController;
  StreamSubscription? _locationSubscription;

  final double _zoom = 10;
  final double _tilt = 0;
  final double _bearing = 30;

  final PolylinePoints _polylinePoints = PolylinePoints();
  final List<LatLng> _polylineCoordinates = [];

  final List<Marker> _markers = [];
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    var taskProvider = context.read<TaskProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _locationSubscription = LocationService.getPosition().listen((position) {
        if (taskProvider.taskStatus == RunningTaskStatus.started ||
            taskProvider.taskStatus == RunningTaskStatus.captureVideo) {
          var latlng = LatLng(position.latitude, position.longitude);
          taskProvider.setCurrentLocation(latlng);
          if (mounted) {
            setState(() {
              _updateCurrentLocation();
              _setPolylines();
            });
          }
          if (taskProvider.getDistanceInMetres() <= 100) {
            taskProvider.onChangeTaskStatus(RunningTaskStatus.captureVideo);
          } else {
            taskProvider.onChangeTaskStatus(RunningTaskStatus.started);
          }
        }
      }, cancelOnError: true);
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    var taskProvider = context.read<TaskProvider>();
    var user = context.read<UserProvider>().user;

    Uint8List? _pinBlueIcon =
        await _getBytesFromAsset(AppAssets.pinIconBlue, 100);
    Uint8List? _pinRedIcon =
        await _getBytesFromAsset(AppAssets.pinIconRed, 100);
    Uint8List? _currentLocation =
        await _getBytesFromAsset(AppAssets.currentLocation, 100);

    setState(() {
      // Set GoogleMapController and Map Style
      _googleMapController = controller;
      _googleMapController?.setMapStyle(mapStyle);

      // Add Driver current location marker
      if (taskProvider.currentLatLng != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('Current Location'),
            position: taskProvider.currentLatLng ?? const LatLng(0, 0),
            infoWindow: const InfoWindow(title: 'Your Current Location'),
            icon: _currentLocation != null
                ? BitmapDescriptor.fromBytes(_currentLocation)
                : BitmapDescriptor.defaultMarker,
            rotation: 0,
          ),
        );
      }

      // Add Task location markers
      for (var taskLocation in widget.taskLocations) {
        _markers.add(
          Marker(
            markerId: MarkerId(taskLocation.taskLocationId ?? ''),
            position: LatLng(taskLocation.lat ?? 0.0, taskLocation.long ?? 0.0),
            infoWindow: InfoWindow(title: taskLocation.address ?? ''),
            icon: taskLocation.isAvailable()
                ? _pinBlueIcon != null
                    ? BitmapDescriptor.fromBytes(_pinBlueIcon)
                    : BitmapDescriptor.defaultMarker
                : _pinRedIcon != null
                    ? BitmapDescriptor.fromBytes(_pinRedIcon)
                    : BitmapDescriptor.defaultMarker,
            rotation: 0,
            onTap: () async {
              if (taskLocation.status == 1 &&
                  taskLocation.userId == user?.userId) {
                Navigator.pushNamed(
                  context,
                  Routes.taskLocationDetails,
                  arguments: TaskLocationArgs(
                    taskLocation: taskLocation,
                    isAccepted: true,
                  ),
                );
              } else {
                var result = await AppDialogs.showTaskDetailSheet(context,
                    taskLocation: taskLocation);

                if (result == 1) {
                  Navigator.pushNamed(
                    context,
                    Routes.taskLocationDetails,
                    arguments: TaskLocationArgs(taskLocation: taskLocation),
                  );
                } else if (result == 2) {
                  var granted = PreferencesService.pref?.getBool(
                          Preferences.doNotShowAgainBillBoardsDetails) ??
                      false;

                  if (granted) {
                    _acceptTaskHandler(taskLocation);
                  } else {
                    var accepted = (await AppDialogs.showBillBoardDetailsDailog(
                            context)) ??
                        false;
                    if (accepted) {
                      _acceptTaskHandler(taskLocation);
                    }
                  }
                }
              }
            },
          ),
        );
      }
      // Set Polylines
      _setPolylines();
    });
  }

  void _acceptTaskHandler(TaskLocation taskLocation) {
    var taskProvider = context.read<TaskProvider>();
    var userProvider = context.read<UserProvider>();

    taskProvider
        .acceptTask(
      taskLocationId: taskLocation.taskLocationId,
      userId: userProvider.user?.userId,
    )
        .whenComplete(() {
      taskProvider.setTaskLocation(taskLocation);
      taskProvider.onChangeTaskStatus(RunningTaskStatus.accepted);
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _locationSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: taskProvider.currentLatLng ?? const LatLng(0.0, 0.0),
            zoom: _zoom,
            tilt: _tilt,
            bearing: _bearing,
          ),
          onMapCreated: _onMapCreated,
          markers: Set.from(_markers),
          polylines: _polylines,
          indoorViewEnabled: true,
          zoomControlsEnabled: false,
          myLocationEnabled: false,
          buildingsEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
        );
      },
    );
  }

  Future<void> _setPolylines() async {
    var taskProvider = context.read<TaskProvider>();

    if (taskProvider.polylineLatLngs.length == 2) {
      PolylineResult? result = await _polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        taskProvider.currentPointLatLng,
        taskProvider.taskPointLatLng,
      );
      _polylineCoordinates.clear();

      for (var point in result.points) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      _polylines.add(
        Polyline(
          polylineId: PolylineId(taskProvider.polylineLatLngs.toString()),
          visible: true,
          points: _polylineCoordinates,
          color: Colors.black,
          jointType: JointType.round,
          patterns: [PatternItem.dash(5)],
          width: 5,
        ),
      );

      taskProvider.getDistance();
    }
  }

  // Update driver current location marker
  Future<void> _updateCurrentLocation() async {
    var taskProvider = context.read<TaskProvider>();

    Uint8List? _currentLocation =
        await _getBytesFromAsset(AppAssets.currentLocation, 100);

    if (taskProvider.currentLatLng != null &&
        taskProvider.taskLocation != null) {
      double? _zoomLevel = await _googleMapController?.getZoomLevel();
      CameraPosition cPosition = CameraPosition(
        zoom: _zoomLevel ?? _zoom,
        tilt: _tilt,
        bearing: _bearing,
        target: taskProvider.currentLatLng ?? const LatLng(0.0, 0.0),
      );
      _googleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cPosition));

      _markers.removeWhere((m) => m.markerId.value == 'Current Location');
      _markers.add(
        Marker(
          markerId: const MarkerId('Current Location'),
          position: taskProvider.currentLatLng ?? const LatLng(0, 0),
          infoWindow: const InfoWindow(title: 'Your Current Location'),
          icon: _currentLocation != null
              ? BitmapDescriptor.fromBytes(_currentLocation)
              : BitmapDescriptor.defaultMarker,
          rotation: 0,
        ),
      );
    }
  }

  Future<Uint8List?> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }
}
