import 'package:flutter/foundation.dart';

class CountProvider extends ChangeNotifier {
  
  int _count = 1;

  int get count => _count;

  void updateCount(int newCount) {
    _count = newCount;
    notifyListeners();
  }
}
