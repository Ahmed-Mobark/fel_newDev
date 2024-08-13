import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:football_app/helpers/loading.dart';
import 'package:football_app/helpers/vars.dart';
import 'package:football_app/presentation/screens/groups/group_details_screen.dart';
import 'package:football_app/presentation/screens/screens.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UniLinkClient {
  Future<void> launchAd(String link) async {
    BuildContext? context = Get.context;
    Uri uri = Uri.parse(link);

    if (uri.host != Connection.BASE) {
      try {
        await launchUrl(Uri.parse(link));
        return;
      } catch (e, s) {
        Fluttertoast.showToast(msg: tr('cannot_open_url'));
      }
    }

    if (uri.pathSegments.length < 2) return;
    if (!UniVars.values.contains(uri.pathSegments[0])) return;
    // TODO: Might want to send to crashlytics.

    final id = uri.pathSegments[1];

    try {
      LoadingScreen.show(context!);

      switch (uri.pathSegments[0]) {
        case UniVars.GROUP:
          Get.offAll(() => const WelcomeScreen());
          Get.to(ExploreGroupDetailsScreen(groupId: id));
          break;
      }
    } catch (e, s) {
      Navigator.of(context!).pop();
      Fluttertoast.showToast(msg: tr('cannot_open_url'));
      return;
    }
  }
}
