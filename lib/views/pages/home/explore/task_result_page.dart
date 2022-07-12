import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/routes/app_routes.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TaskResultPage extends StatelessWidget {
  final TaskResult result;

  const TaskResultPage(this.result, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Sizes.s40.h),
            child: Column(
              children: [
                Image.asset(
                  AppAssets.appLogo,
                  height: Sizes.s50.h,
                  width: Sizes.s150.h,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        isSuccessed ? AppAssets.success : AppAssets.failed,
                        height: Sizes.s120.h,
                        width: Sizes.s120.h,
                      ),
                      SizedBox(height: Sizes.s20.h),
                      Text(
                        isSuccessed ? 'Congratulations 🎉' : 'Oops!',
                        style: TextStyle(
                          fontSize: isSuccessed ? Sizes.s24.sp : Sizes.s40.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: kPadding),
                      Text(
                        'Fail to Collect Rewards!',
                        style: TextStyle(
                          fontSize: Sizes.s16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      SizedBox(height: isSuccessed ? 0 : Sizes.s12.h),
                      Text(
                        isSuccessed
                            ? 'Thanks for participating in this task! we have received your Video, will update you in 24-48 hours.'
                            : 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to a type specimen book.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.5,
                          fontSize: Sizes.s14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      SizedBox(height: Sizes.s50.h),
                      WidgetDelegate(
                        shouldShowPrimary: isSuccessed,
                        primaryWidget: () {
                          return PrimaryButton(
                            label: 'Collect More',
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.mainHome,
                                (route) => false,
                              );
                            },
                          );
                        },
                        alternateWidget: () {
                          return PrimaryButton(
                            label: 'Try Again',
                            isOutlined: true,
                            color: AppColors.red,
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.mainHome,
                                (route) => false,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get isSuccessed => result == TaskResult.success;
}
