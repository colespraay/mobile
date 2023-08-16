import 'package:flutter/cupertino.dart';
import 'package:spraay/utils/my_sharedpref.dart';

class AuthProvider extends ChangeNotifier{

  //routing page for bottom nav
  int selectedIndex = 0;
  void onItemTap(int index) {
    selectedIndex = index;
    notifyListeners();
  }


  // bool sWvalueFaceId = false;
  bool? value= MySharedPreference.getSwitchValuesForTouchID()==null? false: MySharedPreference.getSwitchValuesForTouchID();
  void changeSwitch(bool myvalue){
    value=myvalue;
    notifyListeners();
  }

}