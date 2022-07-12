import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/routes/app_routes.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MyRewardPage extends StatefulWidget {
  const MyRewardPage({Key? key}) : super(key: key);

  @override
  State<MyRewardPage> createState() => _MyRewardPageState();
}

class _MyRewardPageState extends State<MyRewardPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UploadedTaskProvider>(
      builder: (context, uploadedTaskProvider, child) {
        return Scaffold(
          appBar: AppBars.homeAppBar(context, title: 'My Rewards'),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(kPadding),
            child: Column(
              children: [
                _buildTotalEarningView(uploadedTaskProvider.totalEarninhg),
                SizedBox(height: kPadding),
                _buildTotalCompletedTaskView(
                    uploadedTaskProvider.completedTasksCount),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalEarningView(num earnings) {
    return Container(
      padding: EdgeInsets.all(kPadding),
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: kGradientColors1,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(Sizes.s12.h),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${earnings.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.s24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Total Earning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.s10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Sizes.s20.h),
          PrimaryButton(
            height: Sizes.s32.h,
            width: Sizes.s100.h,
            fontSize: Sizes.s14.sp,
            isOutlined: true,
            label: 'Pay Out',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCompletedTaskView(int totalCompletedTask) {
    return Container(
      padding: EdgeInsets.all(kPadding),
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: kGradientColors2,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(Sizes.s12.h),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  totalCompletedTask.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.s24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Total Completed Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.s10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Sizes.s20.h),
          IconButton(
            icon: SvgPicture.asset(
              AppAssets.receipt,
              height: Sizes.s28.h,
              width: Sizes.s28.h,
            ),
            onPressed: () {
              Navigator.pushNamed(context, Routes.completedTask);
            },
          ),
        ],
      ),
    );
  }
}
