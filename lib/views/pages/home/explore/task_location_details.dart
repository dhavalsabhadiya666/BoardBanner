import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/routes/arguments.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/views/pages/home/main_home.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class TaskLocationDetailsPage extends StatelessWidget {
  final TaskLocationArgs args;

  const TaskLocationDetailsPage(this.args, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentLatLng = context.read<TaskProvider>().currentLatLng;

    double distance = Geolocator.distanceBetween(
          currentLatLng?.latitude ?? 0.0,
          currentLatLng?.longitude ?? 0.0,
          args.taskLocation.lat ?? 0.0,
          args.taskLocation.long ?? 0.0,
        ) /
        1609.344;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(270),
                    width: ScreenUtil().screenWidth,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Image.asset(
                      AppAssets.coin,
                      height: Sizes.s24.h,
                      width: Sizes.s24.h,
                      filterQuality: FilterQuality.high,
                    ),
                    title: Text(
                      'Rewards',
                      style: TextStyle(
                        fontSize: Sizes.s20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Text(
                      args.taskLocation.getReward(),
                      style: TextStyle(
                        fontSize: Sizes.s24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: Sizes.s20.h),
                  Divider(
                    color: const Color(0xffF2F2F2),
                    height: 0,
                    thickness: Sizes.s1.h,
                  ),
                  SizedBox(height: Sizes.s10.h),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Location',
                      style: TextStyle(
                        fontSize: Sizes.s18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppAssets.location,
                          height: Sizes.s16.h,
                          width: Sizes.s16.h,
                          color: Colors.black,
                        ),
                        SizedBox(width: Sizes.s8.h),
                        Text(
                          '${distance.toStringAsFixed(2)} Miles',
                          style: TextStyle(
                            fontSize: Sizes.s14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Sizes.s10.h),
                  Text(
                    args.taskLocation.locationDescription ?? '',
                    style: TextStyle(
                      fontSize: Sizes.s14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: Sizes.s30.h),
                  SizedBox(
                    height: ScreenUtil().setHeight(180),
                    width: double.infinity,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Sizes.s10.h),
                          child: Image.asset(
                            AppAssets.map,
                            height: ScreenUtil().setHeight(180),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.all(Sizes.s20.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: Sizes.s10.h, vertical: Sizes.s8.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Sizes.s8),
                              color: Colors.white,
                            ),
                            child: Text(
                              args.taskLocation.address ?? '',
                              style: TextStyle(
                                fontSize: Sizes.s10.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Sizes.s30.h),
                  PrimaryButton(
                    label: args.isAccepted ? 'Start' : 'Accept',
                    onPressed: () {
                      _acceptTaskHandler(context);
                    },
                  ),
                  SizedBox(height: Sizes.s20.h),
                ],
              ),
            ),
            _headingWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _headingWidget(BuildContext context) {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: SizedBox(
        height: ScreenUtil().setHeight(250),
        width: ScreenUtil().screenWidth,
        child: Stack(
          children: [
            ImageView(
              imageUrl: args.taskLocation.billboardImage ?? '',
              height: Sizes.s300.h,
              width: ScreenUtil().screenWidth,
            ),
            Container(
              color: Colors.black.withOpacity(0.08),
            ),
            SafeArea(
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: Sizes.s40.h,
                    width: Sizes.s40.h,
                    padding: EdgeInsets.all(Sizes.s6.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.s6.h),
                      color: Colors.white24,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: Sizes.s28.h,
                    ),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      args.taskLocation.billBoardName ?? '',
                      style: TextStyle(
                        fontSize: Sizes.s16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                trailing: SizedBox(width: Sizes.s40.h),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _acceptTaskHandler(BuildContext context) {
    var taskProvider = context.read<TaskProvider>();
    var userProvider = context.read<UserProvider>();

    if (args.isAccepted) {
      taskProvider.setTaskLocation(args.taskLocation);
      taskProvider.onChangeTaskStatus(RunningTaskStatus.accepted);
      taskProvider.onChangeMapView(true);
      currentIndexNotifier.value = 0;
      Navigator.pop(context);
      _rebuild(context);
    } else {
      taskProvider
          .acceptTask(
              taskLocationId: args.taskLocation.taskLocationId,
              userId: userProvider.user?.userId)
          .whenComplete(() {
        taskProvider.setTaskLocation(args.taskLocation);
        taskProvider.onChangeTaskStatus(RunningTaskStatus.accepted);
        taskProvider.onChangeMapView(true);
        currentIndexNotifier.value = 0;
        Navigator.pop(context);
        _rebuild(context);
      });
    }
  }

  void _rebuild(BuildContext context) {
    var taskProvider = context.read<TaskProvider>();
    taskProvider.setLoading(true);
    Future.delayed(const Duration(milliseconds: 300), () {
      taskProvider.setLoading(false);
    });
  }
}
