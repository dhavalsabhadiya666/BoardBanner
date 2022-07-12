part of 'providers.dart';

class UserProvider extends DefaultChangeNotifier {
  UserData? _user;

  StreamSubscription? _userSubscription;

  final UserRepository _userRepository = GetIt.I<UserRepository>();

  void getUser() {
    _userSubscription = _userRepository.userStream().listen((value) {
      _user = value;
      notify();
    }, onDone: () {
      _userSubscription?.cancel();
    }, cancelOnError: true);
  }

  Future<void> savePayPalId(BuildContext context, String paypalId) async {
    try {
      Loader.show(context);
      return await _userRepository.updateUserField(
          FirestoreFields.paypalId, paypalId);
    } finally {
      Loader.dismiss(context);
    }
  }

  Future<void> saveBankDetails(
      BuildContext context, BankDetails bankDetails) async {
    try {
      Loader.show(context);
      return await _userRepository.updateUserField(
          FirestoreFields.bankDetails, bankDetails.toMap());
    } finally {
      Loader.dismiss(context);
    }
  }

  UserData? get user => _user;

  @override
  void dispose() {
    _userSubscription?.cancel();
    _userSubscription = null;
    super.dispose();
  }
}
