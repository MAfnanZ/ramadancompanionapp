import 'package:flutter/material.dart';

class TabSwitcher with ChangeNotifier {
  int _page = 0;

  int get page => _page;

  set page(int newPage) {
    _page = newPage;
    notifyListeners();
  }

  void reset() {
    _page = 0;
    notifyListeners();
  }
}
