
import 'package:url_launcher/url_launcher.dart';
class Helper {
  Future<void> launchUniversalLink(String? stringUrl) async {
    final Uri url = Uri.parse(stringUrl!);
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }
}
