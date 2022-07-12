part of 'app_dialogs.dart';

Future<bool> _showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String description,
  required String buttonText,
}) async {
  return await showCupertinoDialog<bool>(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      title,
                      style: TextStyle(
                        fontSize: Sizes.s14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(
                    color: const Color(0xffF2F2F2),
                    height: 0,
                    thickness: Sizes.s1.h,
                  ),
                  SizedBox(height: Sizes.s10.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: Sizes.s12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  SizedBox(height: Sizes.s20.h),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Cancel',
                          height: ScreenUtil().setHeight(37),
                          fontSize: Sizes.s14.sp,
                          isOutlined: true,
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                      ),
                      SizedBox(width: Sizes.s20.h),
                      Expanded(
                        child: PrimaryButton(
                          label: buttonText,
                          height: ScreenUtil().setHeight(37),
                          fontSize: Sizes.s14.sp,
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Sizes.s16.h),
                ],
              ),
            ),
          );
        },
      ) ??
      false;
}
