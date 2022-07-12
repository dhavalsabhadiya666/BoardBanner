part of 'widgets.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight * 0.22,
      padding: const EdgeInsets.only(top: 20),
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Sizes.s24.h),
          bottomRight: Radius.circular(Sizes.s24.h),
        ),
        color: const Color(0xff293241),
      ),
      child: SafeArea(
        child: Center(
          child: SvgPicture.asset(
            AppAssets.appLogoWhite,
            height: Sizes.s80.h,
            width: Sizes.s200.h,
          ),
        ),
      ),
    );
  }
}

class BottomFooter extends StatelessWidget {
  final Widget child;

  const BottomFooter({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Sizes.s24.h),
          topRight: Radius.circular(Sizes.s24.h),
        ),
        color: const Color(0xff293241),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
