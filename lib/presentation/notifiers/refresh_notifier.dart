import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:football_app/data_layer/api/api_provider.dart';

class RefreshNotifer extends ChangeNotifier {
  refreshToken() async {
    await ApiProvider(httpClient: Dio()).refreshToken();
  }
}
