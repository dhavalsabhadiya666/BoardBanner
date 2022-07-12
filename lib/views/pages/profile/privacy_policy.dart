import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  //
  bool _termsAndConditions = false;
  bool _imageRequirements = false;
  bool _taskInformation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.backAppBar(context, title: 'Privacy Policy'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            children: [
              _ExpandedContainer(
                title: 'Terms & Conditions',
                expanded: _termsAndConditions,
                description:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,  but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                onPressed: () {
                  setState(() {
                    _termsAndConditions = !_termsAndConditions;
                  });
                },
              ),
              SizedBox(height: Sizes.s16.h),
              _ExpandedContainer(
                title: 'Image Requirements',
                expanded: _imageRequirements,
                description:
                    'Photos and Videos can not be captured while driving.  If it looks like the image was taken from the driver seat, it will be rejected.',
                onPressed: () {
                  setState(() {
                    _imageRequirements = !_imageRequirements;
                  });
                },
              ),
              SizedBox(height: Sizes.s16.h),
              _ExpandedContainer(
                title: 'Task Information',
                expanded: _taskInformation,
                description:
                    'Once a task is accepted, user has 24 hours to complete or it will be relisted.  Once relisted, you may accept the job again and have another 24 hours to complete.  You may accept a job a maximum of three times before it will be unavailable to you.  If this happens too many times, user risks having account suspended.',
                onPressed: () {
                  setState(() {
                    _taskInformation = !_taskInformation;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandedContainer extends StatefulWidget {
  final String title;
  final String description;
  final bool expanded;
  final VoidCallback onPressed;

  const _ExpandedContainer({
    Key? key,
    required this.title,
    required this.description,
    required this.expanded,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<_ExpandedContainer> createState() => _ExpandedContainerState();
}

class _ExpandedContainerState extends State<_ExpandedContainer>
    with SingleTickerProviderStateMixin {
  //
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _animationController?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double x = _animationController?.value ?? 0.0;
    double angleX = math.pi / 180 * (180 * x);

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (_animationController?.isCompleted ?? false) {
              _animationController?.reverse();
            } else {
              _animationController?.forward();
            }
            widget.onPressed();
          },
          child: Container(
            padding: EdgeInsets.all(Sizes.s10.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(Sizes.s8.h),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Sizes.s14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: Sizes.s10.h),
                Transform.rotate(
                  angle: -angleX,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: Sizes.s28.h,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        ExpandedSection(
          expand: widget.expanded,
          child: Container(
            margin: EdgeInsets.only(top: Sizes.s10.h),
            padding: EdgeInsets.symmetric(
                horizontal: Sizes.s10.h, vertical: Sizes.s8.h),
            decoration: BoxDecoration(
              color: const Color(0xffF9F9F9),
              borderRadius: BorderRadius.circular(Sizes.s8.h),
            ),
            child: Text(
              widget.description,
              style: TextStyle(
                fontSize: Sizes.s14.sp,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
