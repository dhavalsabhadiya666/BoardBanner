part of 'explore.dart';

class TaskListView extends StatefulWidget {
  final List<TaskLocation> taskLocations;

  const TaskListView(this.taskLocations, {Key? key}) : super(key: key);

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WidgetDelegate(
        shouldShowPrimary: widget.taskLocations.isNotEmpty,
        primaryWidget: () {
          return ListView.builder(
            itemCount: widget.taskLocations.length,
            padding:
                EdgeInsets.fromLTRB(kPadding, Sizes.s160.h, kPadding, kPadding),
            itemBuilder: (context, index) {
              var taskLocation = widget.taskLocations[index];
              return Padding(
                padding:  EdgeInsets.symmetric(vertical: Sizes.s10.h),
                child: _TaskLocationListTile(
                  taskLocation: taskLocation,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.taskLocationDetails,
                      arguments: TaskLocationArgs(taskLocation: taskLocation),
                    );
                  },
                ),
              );
            },
          );
        },
        alternateWidget: () {
          return const EmptyWidget('No Tasks');
        },
      ),
    );
  }
}

class _TaskLocationListTile extends StatelessWidget {
  final TaskLocation taskLocation;
  final VoidCallback onPressed;

  const _TaskLocationListTile({
    Key? key,
    required this.taskLocation,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentLatLng = context.read<TaskProvider>().currentLatLng;
    var user = context.read<UserProvider>().user;
    //
    double distance = Geolocator.distanceBetween(
          currentLatLng?.latitude ?? 0.0,
          currentLatLng?.longitude ?? 0.0,
          taskLocation.lat ?? 0.0,
          taskLocation.long ?? 0.0,
        ) /
        1609.344;

    bool isAccepted = taskLocation.isAccepted(user?.userId ?? '') ||
        taskLocation.isCompleted(user?.userId ?? '') ||
        taskLocation.forApproval(user?.userId ?? '');

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.s12.h),
          border: Border.all(
            width: Sizes.s1.h,
            color: isAccepted
                ? AppColors.primary.withOpacity(0.2)
                : AppColors.secondary.withOpacity(0.2),
          ),
          color: isAccepted
              ? AppColors.primary.withOpacity(0.02)
              : AppColors.secondary.withOpacity(0.05),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Sizes.s10.h),
                topRight: Radius.circular(Sizes.s10.h),
              ),
              child: CachedNetworkImage(
                imageUrl: taskLocation.billboardImage ?? '',
                height: ScreenUtil().setHeight(120),
                width: ScreenUtil().screenWidth,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                placeholder: (context, url) {
                  return Container(
                    height: ScreenUtil().setHeight(150),
                    width: ScreenUtil().screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Sizes.s10.h),
                        topRight: Radius.circular(Sizes.s10.h),
                      ),
                    ),
                  ).toShimmer();
                },
                errorWidget: (context, url, error) {
                  return Container(
                    height: ScreenUtil().setHeight(150),
                    width: ScreenUtil().screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Sizes.s10.h),
                        topRight: Radius.circular(Sizes.s10.h),
                      ),
                    ),
                  ).toShimmer();
                },
              ),
            ),
            SizedBox(height: Sizes.s8.h),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Sizes.s10.h, vertical: Sizes.s4.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          taskLocation.billBoardName ?? '',
                          style: TextStyle(
                            fontSize: Sizes.s16.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: Sizes.s10.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.location,
                            height: Sizes.s16.h,
                            width: Sizes.s16.h,
                          ),
                          SizedBox(width: Sizes.s6.h),
                          Text(
                            '${distance.toStringAsFixed(2)} Miles',
                            style: TextStyle(
                              fontSize: Sizes.s12.h,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Sizes.s8.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          taskLocation.locationDescription ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Sizes.s12.h,
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(width: Sizes.s10.h),
                      Text(
                        taskLocation.getReward(),
                        style: TextStyle(
                          fontSize: Sizes.s20.h,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Sizes.s2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
