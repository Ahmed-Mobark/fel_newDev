// ignore_for_file: unnecessary_null_comparison, unrelated_type_equality_checks

import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:football_app/core/providers.dart';
import 'package:football_app/firebase_options.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/helpers/notification_helper.dart';
import 'package:football_app/helpers/unilink_client.dart';
import 'package:football_app/presentation/screens/home/video_splash.dart';
import 'package:football_app/services/checkinternet.dart';
import 'package:football_app/services/internet_connection.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:uni_links/uni_links.dart' as uni_links;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];
  RxSharedPreferencesConfigs.logger = null;
  await EasyLocalization.ensureInitialized();
  ConnectionUtilProvider.initialize();

  await Firebase.initializeApp(
    name: 'football_app',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    EasyLocalization(
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('ar'),
        Locale('es'),
        Locale('pt'),
      ],
      path: 'assets/lang',
      fallbackLocale: Platform.localeName != 'ar' ||
              Platform.localeName != 'en' ||
              Platform.localeName != 'es' ||
              Platform.localeName != 'pt'
          ? const Locale('en')
          : Locale(Platform.localeName),
      child: const MyApp(),
    ),
  );
}
//dy mn 3geyb eldonia

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

  @override
  void initState() {
    super.initState();
    NotificationHelper();
    _initUniLinks();
    InternetFunction.isConnectedToInternet.stream
        .listen(internetConnectionHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (rxPrefs.getInt('count') == 0 || rxPrefs.getInt('count') == null) {
        count = 0;
      }

      count += 1;
      rxPrefs.setInt('count', count);
    });
  }

  internetConnectionHandler(bool isConnected) {
    // SnackBar snackBar;
    // if (isConnected) {
    // //  snackBar = const SnackBar(content: Text("check your internet"));
    // } else {
    //  snackBar = const
    // }

    !isConnected
        ? snackbarKey.currentState?.showSnackBar(
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
          )
        : print("internet back");
  }

  StreamSubscription? _sub;
  bool fromUniLink = false;

  _initUniLinks() async {
    try {
      // wait until material app gets involved in context;
      await Future.delayed(const Duration(seconds: 3), () {});
      String? initialLink = await uni_links.getInitialLink();
      if (isNotBlank(initialLink)) {
        fromUniLink = true;
        setState(() {});
        await UniLinkClient().launchAd(initialLink!);
      } else {
        Uri? initialUri = await uni_links.getInitialUri();
        if (initialUri != null) {
          fromUniLink = true;
          setState(() {});
          await UniLinkClient().launchAd(initialUri.toString());
        }
      }
    } on PlatformException catch (e, s) {
      fromUniLink = false;
      setState(() {});
      Fluttertoast.showToast(msg: tr('cannot_open_url'));
    }

    _sub = uni_links.linkStream.listen(
      (String? link) async {
        if (isNotBlank(link)) {
          fromUniLink = true;
          setState(() {});
          await UniLinkClient().launchAd(link!);
        } else {
          _sub = uni_links.uriLinkStream.listen(
            (link) async {
              fromUniLink = true;
              setState(() {});
              await UniLinkClient().launchAd(link.toString());
            },
            onError: (e, s) {
              fromUniLink = false;
              setState(() {});
              Fluttertoast.showToast(msg: tr('cannot_open_url'));
            },
          );
        }
      },
      onError: (e, s) {
        fromUniLink = false;
        setState(() {});
        Fluttertoast.showToast(msg: tr('cannot_open_url'));
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
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
            // navigatorKey: navigatorKey,
            navigatorKey: fromUniLink ? Get.key : navigatorKey,
            title: kAppName,
            theme: darkThemeData(context),
            // themeMode: ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: routesApp,
            scaffoldMessengerKey: snackbarKey,
            home: VideoSplashPage(fromUniLink: fromUniLink),
            //SplashScreen(),
          ),
        );
      },
    );
  }
}
