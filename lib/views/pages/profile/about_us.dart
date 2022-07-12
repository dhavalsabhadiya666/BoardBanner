import 'dart:ui';

import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final List<String> _aboutUs = [
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    ' It has survived not only five centuries,  but also the leap into electronic typesetting, remaining essentially unchanged.',
    'It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
  ];

  final TextStyle _textStyle = TextStyle(
    fontSize: Sizes.s14.sp,
    color: AppColors.darkGrey,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: kPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(320),
                      width: ScreenUtil().screenWidth,
                    ),
                    ListView.builder(
                      itemCount: _aboutUs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: kPadding),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: Sizes.s12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('•',
                                  style: _textStyle.copyWith(
                                      fontSize: Sizes.s20.h)),
                              SizedBox(width: Sizes.s10.h),
                              Expanded(
                                  child:
                                      Text(_aboutUs[index], style: _textStyle)),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            _headingWidget(),
          ],
        ),
      ),
    );
  }

  Widget _headingWidget() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: SizedBox(
        height: ScreenUtil().setHeight(300),
        width: ScreenUtil().screenWidth,
        child: Stack(
          children: [
            ImageView(
              imageUrl:
                  'https://www.pewtrusts.org/-/media/post-launch-images/2019/06/gettyimages937434808jpgmaster/16x9_m.jpg',
              height: Sizes.s300.h,
              width: ScreenUtil().screenWidth,
            ),
            Container(
              color: Colors.black.withOpacity(0.1),
            ),
            SafeArea(
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.s8.h),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: Sizes.s14.h, sigmaY: Sizes.s14.h),
                      child: Container(
                        height: Sizes.s40.h,
                        width: Sizes.s40.h,
                        padding: EdgeInsets.all(Sizes.s6.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.s6.h),
                          color: Colors.white24,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: Sizes.s28.h,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: Sizes.s16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                trailing: SizedBox(width: Sizes.s40.h),
              ),
            )
          ],
        ),
      ),
    );
  }
}
