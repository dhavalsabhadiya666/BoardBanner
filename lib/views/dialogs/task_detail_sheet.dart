part of 'app_dialogs.dart';

class _TaskDetailSheet extends StatefulWidget {
  final TaskLocation taskLocation;

  const _TaskDetailSheet({Key? key, required this.taskLocation})
      : super(key: key);

  // 0 = close, 1 = View More, 2 = Direction
  static Future<int?> showSheet(
      BuildContext context, TaskLocation taskLocation) async {
    return await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      builder: (context) {
        return _TaskDetailSheet(taskLocation: taskLocation);
      },
    );
  }

  @override
  State<_TaskDetailSheet> createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends State<_TaskDetailSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.s14.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Sizes.s8.h),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: Sizes.s4.h,
                width: Sizes.s48.w,
                decoration: BoxDecoration(
                  color: const Color(0xffC4C4C4),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: Sizes.s2.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                widget.taskLocation.billBoardName ?? '',
                style: TextStyle(
                  fontSize: Sizes.s20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              trailing: InkWell(
                onTap: () {
                  Navigator.pop(context, 0);
                },
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ),
            SizedBox(height: Sizes.s2.h),
            Divider(
              color: const Color(0xffF2F2F2),
              height: 0,
              thickness: Sizes.s1.h,
            ),
            SizedBox(height: Sizes.s20.h),
            ImageView(
              imageUrl: widget.taskLocation.billboardImage ?? '',
              height: ScreenUtil().setHeight(150),
              width: ScreenUtil().screenWidth,
              radius: Sizes.s10.h,
            ),
            SizedBox(height: Sizes.s6.h),
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
                '\$${widget.taskLocation.rewardAmount}',
                style: TextStyle(
                  fontSize: Sizes.s24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: Sizes.s10.h),
            Text(
              widget.taskLocation.address ?? '',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: Sizes.s12.sp,
                height: 1.5,
                fontWeight: FontWeight.w400,
                color: AppColors.darkGrey,
              ),
            ),
            SizedBox(height: Sizes.s50.h),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'View More',
                    isOutlined: true,
                    onPressed: () {
                      Navigator.pop(context, 1);
                    },
                  ),
                ),
                SizedBox(width: Sizes.s20.h),
                Expanded(
                  child: PrimaryButton(
                    label: 'Direction',
                    onPressed: () {
                      Navigator.pop(context, 2);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: Sizes.s20.h),
          ],
        ),
      ),
    );
  }
}
