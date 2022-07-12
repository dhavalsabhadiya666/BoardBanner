import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/routes/app_routes.dart';
import 'package:adscope/repositories/authentication_repository.dart';
import 'package:adscope/services/services.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //
  void _navigateToNext() {
    bool onboardingCompleted =
        PreferencesService.pref?.getBool(Preferences.onboardingCompleted) ??
            false;
    Future.delayed(const Duration(seconds: 2), () {
      if (onboardingCompleted) {
        AuthenticationStatus status =
            AuthenticationRepository.getAuthenticationStatus();

        if (status == AuthenticationStatus.authenticated) {
          Navigator.pushReplacementNamed(context, Routes.mainHome);
        } else {
          Navigator.pushReplacementNamed(context, Routes.signIn);
        }
      } else {
        Navigator.pushReplacementNamed(context, Routes.onboarding);
      }
    });
    MessagingService.requestPermission();
  }

  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        AppAssets.splash,
        height: double.infinity,
        width: double.infinity,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
