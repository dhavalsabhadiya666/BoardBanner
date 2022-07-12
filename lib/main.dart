import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/core/routes/app_routes.dart';
import 'package:adscope/core/utils/utils.dart';
import 'package:adscope/injector.dart';
import 'package:adscope/providers/providers.dart';
import 'package:adscope/services/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  PreferencesService.pref = await SharedPreferences.getInstance();

  Injector.init();

  runApp(const AdScopeApp());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  MessagingService.onBackgroundMessage(_onBackgroundMessageHandler);
}

Future<void> _onBackgroundMessageHandler(RemoteMessage message) async {
  NavigatorState? state = navigatorKey.currentState;
  if (state != null) {
    OverlayState? overlay = state.overlay;
    if (overlay != null) {}
  }
}

class AdScopeApp extends StatelessWidget {
  const AdScopeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UploadedTaskProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        navigatorKey: navigatorKey,
        theme: ThemeUtils.theme,
        initialRoute: Routes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: const ScrollBehaviorModified(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                ScreenUtil.init(
                  constraints,
                  designSize: Size(constraints.maxWidth, constraints.maxHeight),
                );
                return child ?? const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}
