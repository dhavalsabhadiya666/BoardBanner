part of 'widgets.dart';

class TaskListTile extends StatelessWidget {
  final TaskLocation taskLocation;
  final VoidCallback? onPressed;

  const TaskListTile({
    Key? key,
    required this.taskLocation,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xffF9F9F9);
    double height = Sizes.s110.h;

    switch (taskLocation.uploadedTaskStatus) {
      case 1:
        color = const Color(0xffF5FBF6);
        height = Sizes.s110.h;
        break;
      case 2:
        color = const Color(0xffFEF7F6);
        height = ScreenUtil().setHeight(135);
        break;
      default:
    }

    var dateTime =
        taskLocation.accepetedRejectedDate?.add(const Duration(hours: 24)) ??
            DateTime.now();

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(vertical: Sizes.s8.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Sizes.s12.h),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Sizes.s12.h),
                bottomLeft: Radius.circular(Sizes.s12.h),
              ),
              child: ImageView(
                imageUrl: taskLocation.billboardImage ?? '',
                height: height,
                width: Sizes.s80.h,
                radius: 0,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(kPadding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            taskLocation.taskHeading ?? '',
                            style: TextStyle(
                              fontSize: Sizes.s16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: Sizes.s8.h),
                        Text(
                          taskLocation.getReward(),
                          style: TextStyle(
                            fontSize: Sizes.s16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Sizes.s6.h),
                    _buildMilesAndDistanceTimeView(context),
                    SizedBox(height: Sizes.s6.h),
                    Text(
                      taskLocation.locationDescription ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        height: 1.4,
                        fontSize: Sizes.s12.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (taskLocation.uploadedTaskStatus == 2)
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.clock,
                                  height: Sizes.s12.h,
                                  width: Sizes.s12.h,
                                  color: AppColors.red,
                                ),
                                SizedBox(width: Sizes.s8.h),
                                Text(
                                  DateTimeUtils.timeleft(dateTime) ??
                                      'Time Ended',
                                  style: TextStyle(
                                    fontSize: Sizes.s10.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Sizes.s10.h),
                          PrimaryButton(
                            color: AppColors.red,
                            isOutlined: true,
                            fontSize: Sizes.s10.sp,
                            label: 'Try Again',
                            height: Sizes.s28.h,
                            width: Sizes.s80.h,
                            onPressed: () {},
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMilesAndDistanceTimeView(BuildContext context) {
    final LocationRepository _locationRepository =
        GetIt.I<LocationRepository>();
    var currentLatLng = context.read<TaskProvider>().currentLatLng;

    return FutureBuilder<Distance?>(
      future: _locationRepository.getDistance(
        start: PointLatLng(
            currentLatLng?.latitude ?? 0.0, currentLatLng?.longitude ?? 0.0),
        end: PointLatLng(taskLocation.lat ?? 0.0, taskLocation.long ?? 0.0),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var distance = snapshot.data;

          Widget text = Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset(
                AppAssets.clock,
                height: Sizes.s12.h,
                width: Sizes.s12.h,
              ),
              SizedBox(width: Sizes.s8.h),
              Text(
                distance?.duration ?? '-',
                style: TextStyle(
                  fontSize: Sizes.s12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
              ),
            ],
          );

          switch (taskLocation.uploadedTaskStatus) {
            case 1:
              text = Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Success',
                    style: TextStyle(
                      fontSize: Sizes.s10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              );
              break;
            case 2:
              text = Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Fail',
                    style: TextStyle(
                      fontSize: Sizes.s10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.red,
                    ),
                  ),
                ],
              );
              break;
            default:
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AppAssets.location,
                      height: Sizes.s14.h,
                      width: Sizes.s14.h,
                    ),
                    SizedBox(width: Sizes.s8.h),
                    Text(
                      '${distance?.distance} Left',
                      style: TextStyle(
                        fontSize: Sizes.s12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: Sizes.s8.h),
              Expanded(child: text)
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
