import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/helpers/helpers.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/repositories/location_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

part 'widget_delegate.dart';
part 'primary_button.dart';
part 'logo_header.dart';
part 'primary_text_field.dart';
part 'soical_auth_button.dart';
part 'app_bars.dart';
part 'loader.dart';
part 'image_view.dart';
part 'app_tab_bar.dart';
part 'dialog_header.dart';
part 'task_list_tile.dart';
part 'expanded_section.dart';

class EmptyWidget extends StatelessWidget {
  final String message;
  const EmptyWidget(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          fontSize: Sizes.s16.h,
          color: AppColors.darkGrey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
