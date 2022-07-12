import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UploadedTaskProvider>(
        builder: (context, taskProvider, child) {
      var tasks = taskProvider.uploadedTasks
          .where((e) => e.status == 1 || e.status == 2)
          .toList();
      return Scaffold(
        appBar: AppBars.backAppBar(context, title: 'Transaction History'),
        body: WidgetDelegate(
          shouldShowPrimary: tasks.isNotEmpty,
          primaryWidget: () {
            return ListView.builder(
              itemCount: tasks.length,
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              itemBuilder: (context, index) {
                var task = tasks[index];
                return TransactionListTile(task);
              },
            );
          },
          alternateWidget: () {
            return const EmptyWidget('No Transaction History');
          },
        ),
      );
    });
  }
}

class TransactionListTile extends StatelessWidget {
  final UploadedTask task;

  const TransactionListTile(this.task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kPadding),
      margin: EdgeInsets.symmetric(vertical: kPadding / 2),
      decoration: BoxDecoration(
        color: task.backgroundColor(),
        borderRadius: BorderRadius.circular(Sizes.s12.h),
      ),
      child: Row(
        children: [
          ImageView(
            imageUrl: task.image ?? '',
            height: Sizes.s48.h,
            width: Sizes.s48.h,
            radius: Sizes.s8.h,
          ),
          SizedBox(width: Sizes.s12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name ?? '',
                  style: TextStyle(
                    fontSize: Sizes.s16.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: Sizes.s2.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.clockLine,
                      height: Sizes.s12.h,
                      width: Sizes.s12.h,
                      color: AppColors.darkGrey,
                    ),
                    SizedBox(width: Sizes.s6.h),
                    Text(
                      DateFormat('dd MMM, yyyy')
                          .format(task.addedOn ?? DateTime.now()),
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: Sizes.s12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: Sizes.s12.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${task.rewardAmount}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Sizes.s18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: Sizes.s6.h),
              Text(
                task.status == 1 ? 'Completed' : 'Under Review',
                style: TextStyle(
                  color: task.statusColor(),
                  fontSize: Sizes.s10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
