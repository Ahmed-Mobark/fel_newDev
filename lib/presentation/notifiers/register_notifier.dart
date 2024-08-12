import 'package:flutter/material.dart';

class RegisterNotifier extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var shirtNameController = TextEditingController();
  var shirtNumberController = TextEditingController();
  void updateShirtName(String name) {
    name = shirtNameController.text;
    notifyListeners();
  }

  void updateShirtNumber(String number) {
    number = shirtNumberController.text;
    notifyListeners();
  }

  String? validateShirtNumber(String? value) {
    if (value == null) {
      return 'Field must not be empty';
    }
    if (value == '0') {
      return 'Field must not be zero';
    }
    if (value.length > 2) {
      return 'Field must contain only 2 numbers';
    }
    return null;
  }

  String? validateShirtName(String? value) {
    if (value == null) {
      return 'Field must not be empty';
    }
    if (value.length > 8) {
      return 'Field must contain only 8 letters';
    }
    return null;
  }
}
