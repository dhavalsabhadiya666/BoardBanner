import 'dart:io';

import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/services/services.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'state_picker.dart';
part 'city_picker.dart';
part 'confirmation_dailog.dart';
part 'billboard_details_dailog.dart';
part 'task_detail_sheet.dart';
part 'image_source_sheet.dart';

class AppDialogs {
  AppDialogs._();

  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String description,
    required String buttonText,
  }) async {
    return _showConfirmationDialog(
      context,
      title: title,
      description: description,
      buttonText: buttonText,
    );
  }

  static Future<Land?> showStatePicker(BuildContext context,
      {required List<Land> states}) {
    return _StatePicker.showSheet(context, states);
  }

  static Future<File?> showImageSourceSheet(BuildContext context) {
    return _ImageSourceSheet.showSheet(context);
  }

  static Future<City?> showCityPicker(BuildContext context,
      {required List<City> cities}) {
    return _CityPicker.showSheet(context, cities);
  }

  static Future<bool?> showBillBoardDetailsDailog(BuildContext context) {
    return _BillBoardDetailsDailog.show(context);
  }

  static Future<int?> showTaskDetailSheet(BuildContext context,
      {required TaskLocation taskLocation}) {
    return _TaskDetailSheet.showSheet(context, taskLocation);
  }
}
