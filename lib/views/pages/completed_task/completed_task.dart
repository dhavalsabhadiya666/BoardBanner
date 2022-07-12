import 'dart:math';

import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CompletedTaskPage extends StatefulWidget {
  const CompletedTaskPage({Key? key}) : super(key: key);

  @override
  State<CompletedTaskPage> createState() => _CompletedTaskPageState();
}

class _CompletedTaskPageState extends State<CompletedTaskPage> {
  //
  final Random _random = Random();

  final List<List<Color>> _colors = [
    kGradientColors3,
    kGradientColors4,
    kGradientColors5,
    kGradientColors6,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadedTaskProvider>(
      builder: (context, taskProvider, child) {
        var tasks = taskProvider.completedTasks;
        return Scaffold(
          appBar: AppBars.backAppBar(context, title: 'Completed Tasks'),
          body: WidgetDelegate(
            shouldShowPrimary: tasks.isNotEmpty,
            primaryWidget: () {
              return ListView.builder(
                itemCount: tasks.length,
                padding: EdgeInsets.symmetric(horizontal: kPadding),
                itemBuilder: (context, index) {
                  var uploadedTask = tasks[index];
                  return _UploadedTaskListTile(
                    task: uploadedTask,
                    colors: _colors[_random.nextInt(_colors.length)],
                  );
                },
              );
            },
            alternateWidget: () {
              return const EmptyWidget('No Completed Tasks');
            },
          ),
        );
      },
    );
  }
}

class _UploadedTaskListTile extends StatelessWidget {
  final UploadedTask task;
  final List<Color> colors;

  const _UploadedTaskListTile(
      {Key? key, required this.task, required this.colors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kPadding),
      margin: EdgeInsets.symmetric(vertical: kPadding / 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(Sizes.s12.h),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: Sizes.s1.h),
            ),
            child: ImageView(
              imageUrl: task.image ?? '',
              height: Sizes.s40.h,
              width: Sizes.s40.h,
              radius: Sizes.s40.h / 2,
            ),
          ),
          SizedBox(width: Sizes.s10.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.s16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: Sizes.s4.h),
                Text(
                  task.description ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.s12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Sizes.s10.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${task.rewardAmount}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Sizes.s24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppAssets.clock,
                    height: Sizes.s10.h,
                    width: Sizes.s10.h,
                    color: Colors.white,
                  ),
                  SizedBox(width: Sizes.s6.h),
                  Text(
                    DateFormat('dd MMM, yyyy')
                        .format(task.addedOn ?? DateTime.now()),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.s10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
