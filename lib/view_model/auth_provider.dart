import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier{

  //routing page for bottom nav
  int selectedIndex = 0;
  void onItemTap(int index) {
    selectedIndex = index;
    notifyListeners();
  }

}