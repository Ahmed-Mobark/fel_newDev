import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:football_app/data_layer/api/api_provider.dart';
import 'package:football_app/models/transactions/transactions_model.dart';

class TransactionsNotifier extends ChangeNotifier {
  MyTransactionsModel? myTransactions;
  bool _myTransactionsLoading = false;
  bool get myTransactionsLoading => _myTransactionsLoading;

  getTransactions() async {
    try {
      _myTransactionsLoading = true;
      await ApiProvider(httpClient: Dio()).getTransactions().then((value) {
        myTransactions = value;
        _myTransactionsLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _myTransactionsLoading = false;
      notifyListeners();
    }
  }
}
