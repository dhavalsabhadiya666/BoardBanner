import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/services/services.dart';
import 'package:adscope/views/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final ValueNotifier<int> currentIndexNotifier = ValueNotifier(0);

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    implements MessagingHandler {
  //
  @override
  void initState() {
    super.initState();
    currentIndexNotifier.value = 0;
    getInitialMessage();
    onMessage();
    onMessageOpenedApp();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var userProvider = context.read<UserProvider>();
      var user = userProvider.user;
      userProvider.getUser();

      var uploadedTaskProvider = context.read<UploadedTaskProvider>();
      uploadedTaskProvider.getUploadedTasks(user?.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndexNotifier,
      builder: (context, currentIndex, child) {
        return Scaffold(
          body: _buildBody(currentIndex),
          bottomNavigationBar: _buildBottomNavigationBar(currentIndex),
        );
      },
    );
  }

  Widget? _buildBody(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return const ExplorePage();
      case 1:
        return const MyTaskPage();
      case 2:
        return const MyRewardPage();
      case 3:
        return const NotificationsPage();
      case 4:
        return const ProfilePage();

      default:
    }
    return null;
  }

  Widget _buildBottomNavigationBar(int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        currentIndexNotifier.value = index;
      },
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontSize: Sizes.s12.sp,
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: Sizes.s12.sp,
        color: AppColors.tertiary,
        fontWeight: FontWeight.w400,
      ),
      items: [
        BottomNavigationBarItem(
          label: 'Explore',
          icon: _buildImageIcon(AppAssets.exploreLine,
              bgColor: Colors.transparent),
          activeIcon: _buildImageIcon(AppAssets.explore),
        ),
        BottomNavigationBarItem(
          label: 'Task',
          icon:
              _buildImageIcon(AppAssets.taskLine, bgColor: Colors.transparent),
          activeIcon: _buildImageIcon(AppAssets.task),
        ),
        BottomNavigationBarItem(
          label: 'Reward',
          icon: _buildImageIcon(AppAssets.rewardLine,
              bgColor: Colors.transparent),
          activeIcon: _buildImageIcon(AppAssets.reward),
        ),
        BottomNavigationBarItem(
          label: 'Notifications',
          icon: _buildImageIcon(AppAssets.notificationLine,
              bgColor: Colors.transparent),
          activeIcon: _buildImageIcon(AppAssets.notification),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: _buildImageIcon(AppAssets.profileLine,
              bgColor: Colors.transparent),
          activeIcon: _buildImageIcon(AppAssets.profile),
        ),
      ],
    );
  }

  Widget _buildImageIcon(String imagePath,
      {Color bgColor = AppColors.primary10, double size = 35}) {
    return Container(
      height: ScreenUtil().setHeight(size),
      width: ScreenUtil().setHeight(size),
      decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
      child: Padding(
        padding: EdgeInsets.all(Sizes.s6.h),
        child: Image.asset(imagePath, filterQuality: FilterQuality.high),
      ),
    );
  }

  @override
  void getInitialMessage() {
    MessagingService.getInitialMessage((message) {});
  }

  @override
  void onMessage() {
    MessagingService.onMessage((message) {});
  }

  @override
  void onMessageOpenedApp() {
    MessagingService.onMessageOpenedApp((message) {});
  }
}
