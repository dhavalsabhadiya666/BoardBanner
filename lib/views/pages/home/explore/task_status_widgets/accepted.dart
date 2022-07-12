part of 'task_status_widgets.dart';

class TaskStatusAccepted extends StatelessWidget {
  final TaskLocation? taskLocation;
  final VoidCallback onBack;
  final VoidCallback onStart;
  final VoidCallback onCancel;

  const TaskStatusAccepted({
    Key? key,
    required this.taskLocation,
    required this.onBack,
    required this.onStart,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Sizes.s20.h,
          Sizes.s20.h,
          Sizes.s20.h,
          Sizes.s40.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeaderBar(),
            _buildStartTaskCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          child: Container(
            height: Sizes.s44.h,
            width: Sizes.s44.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.s8.h),
              color: Colors.white,
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: Sizes.s24.h,
            ),
          ),
        ),
        SizedBox(width: Sizes.s20.h),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s10.h),
            height: Sizes.s44.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.s8.h),
              color: Colors.white,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              taskLocation?.taskHeading ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Sizes.s16.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartTaskCard(BuildContext context) {
    var user = context.read<UserProvider>().user;
    var taskProvider = context.read<TaskProvider>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(Sizes.s24.h),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: Sizes.s16.h, sigmaY: Sizes.s16.h),
        child: Container(
          padding: EdgeInsets.fromLTRB(
              Sizes.s14.h, Sizes.s6.h, Sizes.s14.h, Sizes.s14.h),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.s24.h),
            color: Colors.white.withOpacity(0.01),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ImageView(
                  imageUrl: user?.photoUrl ?? '',
                  height: Sizes.s50.h,
                  width: Sizes.s50.h,
                  radius: Sizes.s50.h / 2,
                ),
                title: Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: taskProvider.distance?.duration ?? '-',
                        style: TextStyle(
                          fontSize: Sizes.s14.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFontFamily.poppins,
                        ),
                        children: [
                          WidgetSpan(child: SizedBox(width: Sizes.s10.h)),
                          TextSpan(
                            text: taskProvider.distance?.distance ?? '-',
                            style: TextStyle(
                              fontSize: Sizes.s12.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppFontFamily.poppins,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                subtitle: Text(
                  taskLocation?.address ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Sizes.s12.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFontFamily.poppins,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.direcation,
                      height: Sizes.s18.h,
                      width: Sizes.s18.h,
                    ),
                    SizedBox(width: Sizes.s30.h),
                    Image.asset(
                      AppAssets.arrow,
                      height: Sizes.s16.h,
                      width: Sizes.s16.h,
                    ),
                  ],
                ),
              ),
              SizedBox(height: Sizes.s8.h),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: 'Cancel',
                      height: Sizes.s38.h,
                      fontSize: Sizes.s12.sp,
                      isOutlined: true,
                      onPressed: onCancel,
                    ),
                  ),
                  SizedBox(width: Sizes.s20.h),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Start',
                      height: Sizes.s38.h,
                      fontSize: Sizes.s12.sp,
                      onPressed: onStart,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
