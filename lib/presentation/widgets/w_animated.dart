part of 'widgets.dart';

class HorizontalAnimation extends StatelessWidget {
  const HorizontalAnimation({
    Key? key,
    required this.child,
    this.duration = 200,
  }) : super(key: key);

  final Widget child;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      duration: Duration(milliseconds: duration),
      child: child,
    );
  }
}

class VerticalAnimation extends StatelessWidget {
  const VerticalAnimation({Key? key, required this.child, this.duration = 200})
      : super(key: key);

  final Widget child;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return SlideInDown(
      duration: Duration(milliseconds: duration),
      child: child,
    );
  }
}

class SlideDownAnimation extends StatelessWidget {
  const SlideDownAnimation({Key? key, required this.child, this.duration = 200})
      : super(key: key);

  final Widget child;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return SlideInUp(
      duration: Duration(milliseconds: duration),
      child: child,
    );
  }
}
