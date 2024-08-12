part of 'widgets.dart';

SnackBar errorSnackBar(String message) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.red,
  );
}

SnackBar successSnackBar(String message) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.green,
  );
}
