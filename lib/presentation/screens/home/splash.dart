part of '../screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkUserToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BounceInDown(
          duration: const Duration(milliseconds: 1900),
          child: Image(
            image: AssetImage(kSplashIcon),
            width: 20.h,
          ),
        ),
      ),
    );
  }

  void checkUserToken() async {
    final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
    final String? token = await rxPrefs.getString('token');
    final String? expDate = await rxPrefs.getString('expDate');

    if (token == null) {
      const Duration(seconds: 2).delay(
        () => Get.offAndToNamed('/login'),
      );
    } else if (DateTime.now().isAfter(DateTime.parse(expDate ?? ''))) {
      const Duration(seconds: 2).delay(
        () => Get.offAndToNamed('/login'),
      );
    } else {
      const Duration(seconds: 2).delay(
        () => Get.offAndToNamed('/welcome'),
      );
    }
  }
}
