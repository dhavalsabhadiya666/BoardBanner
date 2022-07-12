part of 'task_status_widgets.dart';

class TaskStatusCapture extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onCapture;

  const TaskStatusCapture({
    Key? key,
    required this.onBack,
    required this.onCapture,
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
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
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
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Sizes.s8.h)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Sizes.s10.h, vertical: Sizes.s8.h),
                    child: Text(
                      'Capture Video',
                      style: TextStyle(
                        fontSize: Sizes.s10.h,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Sizes.s14.h),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(Sizes.s8.h),
                    child: IconButton(
                      icon: Image.asset(
                        AppAssets.camera,
                        height: Sizes.s30.h,
                        width: Sizes.s30.h,
                        filterQuality: FilterQuality.high,
                      ),
                      onPressed: onCapture,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
