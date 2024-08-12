import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_volume/real_volume.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoSplashPage extends StatefulWidget {
  const VideoSplashPage({Key? key, this.fromUniLink = false}) : super(key: key);
  final bool fromUniLink;

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<VideoSplashPage> {
  late VideoPlayerController _controller;
  bool _visible = false;
  double? currentVolume;
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    RealVolume.onVolumeChanged.listen((event) async {
      setState(() {
        currentVolume = event.volumeLevel;
      });
      log(currentVolume.toString());
    });
    _controller = VideoPlayerController.asset("assets/video/splash_video.mp4");
    _controller.initialize().then((_) {
      _controller.setVolume(currentVolume ?? 1);
      _controller.setLooping(false);
      Timer(const Duration(milliseconds: 100), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });

    Future.delayed(const Duration(seconds: 4), () {
      checkUserToken(widget.fromUniLink);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  Future<void> _getData() async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    await authNotifier.getCountries();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: VideoPlayer(_controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            _getVideoBackground(),
          ],
        ),
      ),
    );
  }
}

void checkUserToken(bool fromUniLink) async {
  final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
  final String? token = await rxPrefs.getString('token');
  final String? expDate = await rxPrefs.getString('expDate');

  if (token == null) {
    if (!fromUniLink) {
      const Duration(seconds: 2).delay(
        () => Get.offAndToNamed('/login'),
      );
    }
  }
  //  else if (DateTime.now().isAfter(DateTime.parse(expDate ?? ''))) {
  //   const Duration(seconds: 2).delay(
  //     () => Get.offAndToNamed('/login'),
  //   );
  // }
  else {
    if (!fromUniLink) {
      const Duration(seconds: 2).delay(
        () => Get.offAndToNamed('/welcome'),
      );
    }
  }
}
