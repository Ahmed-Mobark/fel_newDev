import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data_layer/api/api_provider.dart';

class AppSettingsNotifier extends ChangeNotifier {
  String? terms;
  String? policy;

  bool _termsLoading = true;
  bool get termsLoading => _termsLoading;

  bool _policyLoading = true;
  bool get policyLoading => _policyLoading;

  Future<void> getAppTerms() async {
    _termsLoading = true;
    terms = '';
    notifyListeners();
    try {
      terms = await ApiProvider(httpClient: Dio()).getAppTerms();
      _termsLoading = false;
      notifyListeners();
    } catch (e) {
      _termsLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPrivacyPolicy() async {
    _policyLoading = true;
    policy = '';
    notifyListeners();
    try {
      policy = await ApiProvider(httpClient: Dio()).getPrivacyPolicy();
      _policyLoading = false;
      notifyListeners();
    } catch (e) {
      _policyLoading = false;
      notifyListeners();
    }
  }
}
