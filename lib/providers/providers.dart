import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/repositories/app_repository.dart';
import 'package:adscope/repositories/location_repository.dart';
import 'package:adscope/repositories/task_repository.dart';
import 'package:adscope/repositories/uploaded_task_repository.dart';
import 'package:adscope/repositories/user_repository.dart';
import 'package:adscope/services/services.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart' hide State;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'default_change_notifier.dart';
part 'app_provider.dart';
part 'task_provider.dart';
part 'user_provider.dart';
part 'uploaded_task_provider.dart';
