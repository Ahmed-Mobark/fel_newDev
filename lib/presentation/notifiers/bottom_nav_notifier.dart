import 'package:flutter/material.dart';

class BottomNavigationBarNotifier extends ChangeNotifier {
  int? navbarIndex = 0;
  setNavbarIndex(int? newValue) {
    navbarIndex = newValue;
    notifyListeners();
  }

  List<String> kCaties = [
    "English League",
    "Premier League",
    "LaLiga",
    "EFL Championship",
    "Serie A",
    "Bundesliga",
    "UEFA Europa League",
    "MLS",
    "Ligue 1",
    "UEFA Champions League",
    "Union of European Football",
    "Eredivise",
  ];
}
