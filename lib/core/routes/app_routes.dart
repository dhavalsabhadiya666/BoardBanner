import 'dart:io';

import 'package:adscope/core/enums/enums.dart';
import 'package:adscope/core/routes/arguments.dart';
import 'package:adscope/views/pages/pages.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign_in';
  static const String signUp = '/sign_up';
  static const String forgotPassword = '/forgot_password';
  static const String termsAndConditions = '/terms_and_conditions';
  static const String mainHome = '/main_home';
  static const String changePassword = '/change_password';
  static const String uploadVideo = '/upload_video';
  static const String taskLocationDetails = '/task_location_details';
  static const String completedTask = '/completed_task';
  static const String transactionHistory = '/transaction_history';
  static const String personalDetails = '/personal_details';
  static const String privacyPolicy = '/privacy_policy';
  static const String payoutDetails = '/payout_details';
  static const String aboutUs = '/about_us';
  static const String taskResult = '/task_result';
}

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case Routes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForogotPasswordPage());
      case Routes.termsAndConditions:
        return MaterialPageRoute<bool>(
            builder: (_) => const TermsAndConditionPage());
      case Routes.mainHome:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case Routes.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
      case Routes.uploadVideo:
        return MaterialPageRoute(builder: (_) => UploadVideoPage(args as File));
      case Routes.taskLocationDetails:
        return MaterialPageRoute(
            builder: (_) => TaskLocationDetailsPage(args as TaskLocationArgs));
      case Routes.completedTask:
        return MaterialPageRoute(builder: (_) => const CompletedTaskPage());
      case Routes.transactionHistory:
        return MaterialPageRoute(
            builder: (_) => const TransactionHistoryPage());
      case Routes.personalDetails:
        return MaterialPageRoute(builder: (_) => const PersonalDetailPage());
      case Routes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());
      case Routes.payoutDetails:
        return MaterialPageRoute(builder: (_) => const PayoutDetailsPage());
      case Routes.aboutUs:
        return MaterialPageRoute(builder: (_) => const AboutUsPage());
      case Routes.taskResult:
        return MaterialPageRoute(
            builder: (_) => TaskResultPage(args as TaskResult));
      default:
        return null;
    }
  }
}
