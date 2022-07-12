import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/core/routes/app_routes.dart';
import 'package:adscope/core/routes/arguments.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/models/place_model.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/repositories/location_repository.dart';
import 'package:adscope/repositories/task_repository.dart';
import 'package:adscope/services/services.dart';
import 'package:adscope/views/dialogs/app_dialogs.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'task_status_widgets/task_status_widgets.dart';

part 'task_list_view.dart';
part 'task_map_view.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  //
  final TaskRepository _taskRepository = GetIt.I<TaskRepository>();
  final LocationRepository _locationRepository = GetIt.I<LocationRepository>();

  final TextEditingController _search = TextEditingController();

  bool _isSearching = false;
  List<Place> _places = [];

  @override
  void initState() {
    super.initState();
    var taskProvider = context.read<TaskProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskProvider.getCurrentLocation();
    });
  }

  void _cancelTaskHandler() {
    var taskProvider = context.read<TaskProvider>();

    taskProvider.setLoading(true);
    Future.delayed(const Duration(milliseconds: 300), () {
      taskProvider.onChangeTaskStatus(RunningTaskStatus.none);
      taskProvider.setTaskLocation(null);
      taskProvider.setLoading(false);
    });
  }

  Future<void> _captureVideoHandler() async {
    var granted = await AppDialogs.showConfirmationDialog(
      context,
      title: 'Please confirm you are not driving',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
      buttonText: 'Accept',
    );

    if (granted) {
      File? videoFile = await FileUtils.pickVideo(ImageSource.camera);

      if (videoFile != null) {
        Navigator.pushNamed(context, Routes.uploadVideo, arguments: videoFile);
      } else {
        SnackUtils(context).showSnakBar('Video Capture Failed.');
      }
    }
  }

  Future<void> _onSearchHandler(String qurey) async {
    if (qurey.isNotEmpty) {
      _isSearching = true;
      _places = await _locationRepository.getPlaces(qurey);
    } else {
      _isSearching = false;
      _places.clear();
    }
    _rebuild();
  }

  Future<void> _onPlaceSelectedHandler(Place place) async {
    var taskProvider = context.read<TaskProvider>();

    var location = await _locationRepository.getLatLng(place.description);

    if (location != null) {
      taskProvider.setLoading(true);
      Future.delayed(const Duration(milliseconds: 300), () {
        taskProvider
            .setCurrentLocation(LatLng(location.latitude, location.longitude));
        _isSearching = false;
        _search.clear();
        _places.clear();
        _rebuild();
        taskProvider.setLoading(false);
      });
    }
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TaskProvider, UserProvider>(
      builder: (context, taskProvider, userProvider, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            body: WidgetDelegate(
              shouldShowPrimary:
                  !taskProvider.loading || userProvider.user != null,
              primaryWidget: () {
                return StreamBuilder<List<TaskLocation>>(
                  stream: _taskRepository
                      .getTaskLocations(userProvider.user?.userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var taskLocations = snapshot.data ?? <TaskLocation>[];

                      return WidgetDelegate(
                        shouldShowPrimary: !taskProvider.loading,
                        primaryWidget: () {
                          return Stack(
                            children: [
                              WidgetDelegate(
                                shouldShowPrimary: taskProvider.isMapView,
                                primaryWidget: () {
                                  return TaskMapView(taskLocations);
                                },
                                alternateWidget: () {
                                  return TaskListView(taskLocations);
                                },
                              ),
                              _buildTaskWidgets(),
                            ],
                          );
                        },
                        alternateWidget: () {
                          return Loader.circularProgressIndicator();
                        },
                      );
                    } else {
                      return Loader.circularProgressIndicator();
                    }
                  },
                );
              },
              alternateWidget: () {
                return Loader.circularProgressIndicator();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskWidgets() {
    var taskProvider = context.read<TaskProvider>();

    switch (taskProvider.taskStatus) {
      case RunningTaskStatus.none:
        return TaskStatusNone(
          isSearch: _isSearching,
          searchController: _search,
          places: _places,
          onChanged: _onSearchHandler,
          onPlaceSelected: _onPlaceSelectedHandler,
          onTabChanged: (index) {
            taskProvider.onChangeMapView(index == 0);
          },
        );
      case RunningTaskStatus.accepted:
        return TaskStatusAccepted(
          taskLocation: taskProvider.taskLocation,
          onStart: () {
            taskProvider.onChangeTaskStatus(RunningTaskStatus.started);
          },
          onCancel: _cancelTaskHandler,
          onBack: _cancelTaskHandler,
        );
      case RunningTaskStatus.started:
        return TaskStatusStarted(
          taskLocation: taskProvider.taskLocation,
          onCancel: _cancelTaskHandler,
          onBack: _cancelTaskHandler,
        );
      case RunningTaskStatus.captureVideo:
        return TaskStatusCapture(
          onCapture: _captureVideoHandler,
          onBack: _cancelTaskHandler,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
