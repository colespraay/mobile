import 'package:flutter/cupertino.dart';
import 'package:spraay/utils/my_sharedpref.dart';

class HomeProvider extends ChangeNotifier{
  // bool sWvalueFaceId = false;
  bool? hideWalletvalue= MySharedPreference.getSwitchValuesForWalletBalance()==null? false: MySharedPreference.getSwitchValuesForWalletBalance();
  void changeSwitchForWallet(bool myvalue){
    hideWalletvalue=myvalue;
    notifyListeners();
  }
}