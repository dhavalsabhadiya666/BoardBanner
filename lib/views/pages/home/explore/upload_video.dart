import 'dart:io';
import 'dart:typed_data';

import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/routes/app_routes.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadVideoPage extends StatefulWidget {
  final File file;

  const UploadVideoPage(this.file, {Key? key}) : super(key: key);

  @override
  State<UploadVideoPage> createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  //
  Uint8List? thumbnail;
  //
  @override
  void initState() {
    super.initState();
    _getVideoThumbnail();
  }

  Future<void> _getVideoThumbnail() async {
    var _thumbnail = await FileUtils.getVideoThumbnail(widget.file);
    if (_thumbnail != null) {
      setState(() {
        thumbnail = _thumbnail;
      });
    }
  }

  Future<void> _uploadTaskHandler() async {
    var taskProvider = context.read<TaskProvider>();
    var userProvider = context.read<UserProvider>();

    try {
      await taskProvider
          .uploadTask(
              context: context,
              userId: userProvider.user?.userId,
              file: widget.file)
          .whenComplete(() {
        taskProvider.setTaskLocation(null);
        taskProvider.onChangeTaskStatus(RunningTaskStatus.none);
        Navigator.pushNamed(context, Routes.taskResult,
            arguments: TaskResult.success);
      });
    } catch (e) {
      Navigator.pushNamed(context, Routes.taskResult,
          arguments: TaskResult.failed);
    }
  }

  void _onCancelHandler() {
    var taskProvider = context.read<TaskProvider>();
    taskProvider.setTaskLocation(null);
    taskProvider.onChangeTaskStatus(RunningTaskStatus.none);
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.mainHome, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Scaffold(
          appBar: AppBars.backAppBar(context, title: 'Upload Image'),
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizes.s20.h, vertical: Sizes.s10.h),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (thumbnail != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                thumbnail ?? Uint8List.fromList([]),
                                height: Sizes.s100.h,
                                width: Sizes.s100.h,
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: Sizes.s20.h),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              label: 'Cancel',
                              isOutlined: true,
                              onPressed: _onCancelHandler,
                            ),
                          ),
                          SizedBox(width: Sizes.s20.h),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Upload',
                              onPressed: _uploadTaskHandler,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
