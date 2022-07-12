import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/routes/app_routes.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/models/models.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/repositories/authentication_repository.dart';
import 'package:adscope/repositories/social_auth_repository.dart';
import 'package:adscope/services/services.dart';
import 'package:adscope/views/dialogs/app_dialogs.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          appBar: AppBars.homeAppBar(context, title: 'My Profile'),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: Column(
              children: [
                const SizedBox(height: Sizes.s10),
                _buildProfile(userProvider.user),
                const _ProfileMenuListView(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfile(UserData? user) {
    return Row(
      children: [
        Container(
          height: Sizes.s64.h,
          width: Sizes.s64.h,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.secondary, width: Sizes.s2.h),
          ),
          child: WidgetDelegate(
            shouldShowPrimary: user?.photoUrl != null,
            primaryWidget: () {
              return ImageView(
                imageUrl: user?.photoUrl ?? '',
                height: Sizes.s64.h,
                width: Sizes.s64.h,
                radius: Sizes.s64.h / 2,
              );
            },
            alternateWidget: () {
              return Icon(
                Icons.person,
                size: Sizes.s24.h,
                color: AppColors.secondary,
              );
            },
          ),
        ),
        SizedBox(width: Sizes.s20.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.name ?? '',
                style: TextStyle(
                  fontSize: Sizes.s16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Sizes.s4.h),
              Text(
                user?.email ?? '',
                style: TextStyle(
                  fontSize: Sizes.s14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: Sizes.s10.h),
        IconButton(
          icon: SvgPicture.asset(AppAssets.edit),
          onPressed: () {
            Navigator.pushNamed(context, Routes.personalDetails);
          },
        )
      ],
    );
  }
}

class _ProfileMenuListView extends StatelessWidget {
  const _ProfileMenuListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    List<ProfileMenuItem> items = [
      ProfileMenuItem(
        title: 'Change password',
        leading: AppAssets.password,
        color: const Color(0xffFED337),
        onTap: () {
          Navigator.pushNamed(context, Routes.changePassword);
        },
      ),
      ProfileMenuItem(
        title: 'Payout details',
        leading: AppAssets.payout,
        color: const Color(0xff5BBB7D),
        onTap: () {
          Navigator.pushNamed(context, Routes.payoutDetails);
        },
      ),
      ProfileMenuItem(
        title: 'Transaction History',
        leading: AppAssets.history,
        color: const Color(0xffFE7F37),
        onTap: () {
          Navigator.pushNamed(context, Routes.transactionHistory);
        },
      ),
      ProfileMenuItem(
        title: 'About us',
        leading: AppAssets.about,
        color: const Color(0xffFE657D),
        onTap: () {
          Navigator.pushNamed(context, Routes.aboutUs);
        },
      ),
      ProfileMenuItem(
        title: 'Privacy & Policy',
        leading: AppAssets.privacy,
        color: const Color(0xff484D6D),
        onTap: () {
          Navigator.pushNamed(context, Routes.privacyPolicy);
        },
      ),
      const ProfileMenuItem(
        title: 'Share',
        leading: AppAssets.share,
        color: Color(0xff8D9DA2),
        onTap: ShareUtils.shareApp,
      ),
      ProfileMenuItem(
        title: 'Logout',
        leading: AppAssets.logout,
        color: const Color(0xff1AB7EF),
        onTap: () async {
          _logoutHandler(context);
        },
      ),
    ];
    //
    return ListView.builder(
      itemCount: items.length,
      padding: EdgeInsets.symmetric(vertical: kPadding),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        var item = items[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.s8.h),
          child: ListTile(
            onTap: item.onTap,
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: Sizes.s22.h,
              backgroundColor: item.color,
              child: SvgPicture.asset(
                item.leading ?? '',
                color: Colors.white,
                height: Sizes.s22.h,
                width: Sizes.s22.h,
              ),
            ),
            title: Text(
              item.title,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(15),
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            trailing: Icon(
              item.trailing,
              size: Sizes.s24.h,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }

  Future<void> _logoutHandler(BuildContext context) async {
    var user = context.read<UserProvider>().user;

    final AuthenticationRepository _authenticationRepository =
        GetIt.I<AuthenticationRepository>();

    final SocialAuthRepository _socialAuthRepository =
        GetIt.I<SocialAuthRepository>();

    bool granted = await AppDialogs.showConfirmationDialog(
      context,
      title: 'Confirm Logout',
      description: 'Are you sure you want to Logout?',
      buttonText: 'Logout',
    );

    if (granted) {
      if (user?.authType == AuthType.email) {
        await _authenticationRepository.signOut();
      } else {
        await _socialAuthRepository.signOut(user?.authType);
      }
      MessagingService.deleteToken();
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.signIn,
        (route) => false,
      );
    }
  }
}
