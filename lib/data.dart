import 'package:flutter/material.dart';

class Data extends ChangeNotifier {
  int temp = 0;

  void increment() {
    this.temp++;
    notifyListeners();
  }

  void decrement() {
    this.temp--;
    notifyListeners();
  }
}
