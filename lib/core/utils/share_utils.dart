part of 'utils.dart';

class ShareUtils {
  ShareUtils._();

  static Future<void> shareApp() {
    String playStoreBaseUrl = 'play.google.com/store/apps/details?id=';
    String packageName = 'com.adscope';

    return Share.share('$playStoreBaseUrl$packageName');
  }
}
