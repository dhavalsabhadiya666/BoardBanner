import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/routes/app_routes.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/services/services.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  //
  final PageController _pageController = PageController();
  final Duration _duration300ms = const Duration(milliseconds: 300);
  final Curve _curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _OnboardingView(
            imagePath: AppAssets.onboarding1,
            description:
                'Advertisers need confirmation that their creative message has been installed correctly on billboards.',
            buttonText: 'Next',
            onPressed: () {
              _pageController.animateToPage(
                1,
                duration: _duration300ms,
                curve: _curve,
              );
            },
          ),
          _OnboardingView(
            imagePath: AppAssets.onboarding2,
            description:
                'Earn money by simply taking a video or picture of billboards on highways and streets that you probably pass everyday.',
            buttonText: 'Next',
            onPressed: () {
              _pageController.animateToPage(
                2,
                duration: _duration300ms,
                curve: _curve,
              );
            },
          ),
          _OnboardingView(
            imagePath: AppAssets.onboarding3,
            description:
                'Upload your video or picture and earn real cash rewards for each completed task.',
            buttonText: 'Get Started',
            onPressed: () {
              PreferencesService.pref?.setBool(Preferences.onboardingCompleted, true);
              Navigator.pushReplacementNamed(context, Routes.signIn);
            },
          )
        ],
      ),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  final String imagePath;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const _OnboardingView({
    Key? key,
    required this.imagePath,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Image.asset(
          imagePath,
          filterQuality: FilterQuality.high,
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: Sizes.s50.h),
                Image.asset(
                  AppAssets.appLogo,
                  height: ScreenUtil().setHeight(60),
                  width: ScreenUtil().setHeight(190),
                  filterQuality: FilterQuality.high,
                ),
                SizedBox(height: Sizes.s40.h),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Sizes.s14.sp,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: Sizes.s40.h),
                PrimaryButton(
                  label: buttonText,
                  width: ScreenUtil().screenWidth / 2,
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
