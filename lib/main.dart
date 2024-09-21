import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:football_app/core/providers.dart';
import 'package:football_app/firebase_options.dart';
import 'package:football_app/helpers/notification_helper.dart';
import 'package:football_app/helpers/unilink_client.dart';
import 'package:football_app/presentation/screens/home/video_splash.dart';
import 'package:football_app/services/internet_connection.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:uni_links/uni_links.dart' as uni_links;

import 'helpers/helpers.dart';
import 'services/checkinternet.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize EasyLocalization
  EasyLocalization.logger.enableBuildModes = [];
  await EasyLocalization.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    name: 'football_app',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Internet Connection Checker
  ConnectionUtilProvider.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('ar'),
        Locale('es'),
        Locale('pt'),
      ],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
  final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
  int count = 0;
  StreamSubscription? _internetSub;
  bool fromUniLink = false;

  @override
  void initState() {
    super.initState();

    // Initialize Notification Helper
    NotificationHelper();

    // Handle deep links
    _initUniLinks();

    // Listen to internet connectivity changes
    _internetSub = InternetFunction.isConnectedToInternet.stream
        .listen(internetConnectionHandler);

    // Listen for incoming Firebase messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      count = (await rxPrefs.getInt('count')) ?? 0;
      count += 1;
      rxPrefs.setInt('count', count);
    });
  }

  void internetConnectionHandler(bool isConnected) {
    if (!isConnected) {
      snackbarKey.currentState?.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Center(
            child: Text(
              "check your internet",
              style: Get.textTheme.headlineSmall?.copyWith(
                fontFamily: "Algerian",
              ),
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      print("Internet connection restored");
    }
  }

  Future<void> _initUniLinks() async {
    try {
      // Check for the initial link when the app opens
      final String? initialLink = await uni_links.getInitialLink();
      if (initialLink != null && initialLink.isNotEmpty) {
        fromUniLink = true;
        setState(() {});
        await UniLinkClient().launchAd(initialLink);
      } else {
        final Uri? initialUri = await uni_links.getInitialUri();
        if (initialUri != null) {
          fromUniLink = true;
          setState(() {});
          await UniLinkClient().launchAd(initialUri.toString());
        }
      }
    } catch (e, s) {
      fromUniLink = false;
      setState(() {});
      Fluttertoast.showToast(msg: tr('cannot_open_url'));
      if (kDebugMode) {
        print('Error handling deep link: $e\nStacktrace: $s');
      }
    }
  }

// For iOS and Android, add this to check if the app is installed

  @override
  void dispose() {
    _internetSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: Providers.providersList,
          child: GetMaterialApp(
            locale: context.locale,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            navigatorKey: fromUniLink ? Get.key : navigatorKey,
            title: 'FEL League',
            theme: darkThemeData(context),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: routesApp,
            scaffoldMessengerKey: snackbarKey,
            home: VideoSplashPage(fromUniLink: fromUniLink),
          ),
        );
      },
    );
  }
}
