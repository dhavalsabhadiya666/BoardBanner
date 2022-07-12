import 'package:adscope/core/utils/utils.dart';
import 'package:flutter/material.dart';

part 'app_colors.dart';
part 'app_assets.dart';
part 'app_font_family.dart';
part 'app_sizes.dart';

const String appName = 'AdScope';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const double kBorderRadius = 8;

const double kDialogBorderRadius = 16;

double kPadding = ScreenUtil().setHeight(15);

const String noConnectionMessage =
    'No internet connection, check your connection and try again';

const String googleApiKey = 'AIzaSyAHh8hZqb6EFtxQnmhhFdrkJ0M8Vl8_jlQ';

const String mapStyle = '''
[
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  }
]
   ''';

List<Color> kGradientColors1 = const [Color(0xff82C6F1), Color(0xff7CA0F3)];
List<Color> kGradientColors2 = const [Color(0xffED6691), Color(0xffEA5876)];

List<Color> kGradientColors3 = const [Color(0xff82C6F1), Color(0xff7CA0F3)];
List<Color> kGradientColors4 = const [Color(0xffF4B366), Color(0xffEE9F5C)];
List<Color> kGradientColors5 = const [Color(0xffED6895), Color(0xffEA5874)];
List<Color> kGradientColors6 = const [Color(0xffCB78F2), Color(0xff987EF4)];
