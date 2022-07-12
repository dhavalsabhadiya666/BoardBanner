part of 'task_status_widgets.dart';

class TaskStatusStarted extends StatelessWidget {
  final TaskLocation? taskLocation;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  const TaskStatusStarted({
    Key? key,
    required this.taskLocation,
    required this.onBack,
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
                fontSize: Sizes.s16.h,
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
    var taskProvider = context.read<TaskProvider>();
    Duration duration =
        DateTimeUtils.getDuration(taskProvider.distance?.durationValue);

    int daysUntil = duration.inDays;
    int hoursUntil = duration.inHours - (daysUntil * 24);
    int minUntil =
        duration.inMinutes - (daysUntil * 24 * 60) - (hoursUntil * 60);
    int secUntil = duration.inSeconds -
        (daysUntil * 24 * 60 * 60) -
        (hoursUntil * 60 * 60) -
        (minUntil * 60);

    return Row(
      children: [
        GestureDetector(
          onTap: onCancel,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.s8.h),
            child: BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: Sizes.s14.h, sigmaY: Sizes.s14.h),
              child: Container(
                height: Sizes.s40.h,
                width: Sizes.s40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.s8.h),
                  color: Colors.white10,
                ),
                child: Icon(
                  Icons.close,
                  size: Sizes.s26.h,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: Sizes.s20.h),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.s12.h),
            child: BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: Sizes.s14.h, sigmaY: Sizes.s14.h),
              child: Container(
                padding: EdgeInsets.all(Sizes.s10.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.s12.h),
                  color: Colors.white10,
                ),
                child: Row(
                  children: [
                    _timeWidget(
                      count: hoursUntil.toString().padLeft(2, '0'),
                      label: 'Hours',
                    ),
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: Sizes.s16.sp,
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _timeWidget(
                      count: minUntil.toString().padLeft(2, '0'),
                      label: 'Minutes',
                    ),
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: Sizes.s16.sp,
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _timeWidget(
                      count: secUntil.toString().padLeft(2, '0'),
                      label: 'Seconds',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _timeWidget({required String count, required String label}) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: Sizes.s24.h,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: Sizes.s12.h,
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
