import 'package:flutter/material.dart' hide FontWeight;
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  final Indicator indicator;
  final double size;
  final bool isLight;

  const LoadingWidget({
    Key? key,
    this.indicator = Indicator.ballScaleMultiple,
    this.size = 250,
    this.isLight = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: LoadingIndicator(
          indicatorType: indicator,
          // color: isLight
          //     ? Theme.of(context).primaryColor.withOpacity(0.5)
          //     : Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }
}

class LoadingScreen {
  LoadingScreen._();

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoadingWidget(
                indicator: Indicator.ballScaleMultiple,
              )
            ],
          ),
        );
      },
    );
  }
}
