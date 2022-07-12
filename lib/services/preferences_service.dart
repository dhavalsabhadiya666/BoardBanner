part of 'services.dart';

class PreferencesService {
  static SharedPreferences? pref;
}

class Preferences {
  Preferences._();

  static const String onboardingCompleted = 'onboarding_completed';

  static const String doNotShowAgainBillBoardsDetails =
      'do_not_show_again_bill_boards_details';
}
