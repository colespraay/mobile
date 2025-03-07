import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference{
  static SharedPreferences ? _preferences;

  static Future init() async =>_preferences=await SharedPreferences.getInstance();
  static Future saveEmail(String email) async {_preferences?.setString('email', email);}
  static String getEmail()  {return _preferences?.getString('email')??"";}

  static Future saveToken(String token) async {_preferences?.setString('token', token);}
  static String getToken()  {return _preferences?.getString('token')??"";}

  // static Future savePass(String pass) async {_preferences?.setString('pass', pass);}
  // static String getPass()  {return _preferences?.getString('pass')??"";}

  static Future saveRemember(int remem) async {_preferences?.setInt('remem', remem);}
  static int getRemember()  {return _preferences?.getInt('remem')??0;}

  static Future saveUId(String uid) async {_preferences?.setString('uid', uid);}
  static String getUId()  {return _preferences?.getString('uid')??"";}


  static Future saveFname(String name) async {_preferences?.setString('name', name);}
  static String getFname()  {return _preferences?.getString('name')??"";}

  static Future saveLastname(String last_name) async {_preferences?.setString('last_name', last_name);}
  static String getLastname()  {return _preferences?.getString('last_name')??"";}

  static Future savePhoneNumber(String phone_numb) async {_preferences?.setString('phone_numb', phone_numb);}
  static String getPhoneNumber()  {return _preferences?.getString('phone_numb')??"";}

  static Future saveProfilePicture(String picture) async {_preferences?.setString('picture', picture);}
  static String getProfilePicture()  {return _preferences?.getString('picture')??"";}


  static Future saveVAccName(String virtualAccountName) async {_preferences?.setString('virtualAccountName', virtualAccountName);}
  static String getVAccName()  {return _preferences?.getString('virtualAccountName')??"";}

  static Future saveVAccNumber(String virtualAccountNumber) async {_preferences?.setString('virtualAccountNumber', virtualAccountNumber);}
  static String getVAccNumber()  {return _preferences?.getString('virtualAccountNumber')??"";}

  static Future saveVBankName(String bank_nam) async {_preferences?.setString('bank_nam', bank_nam);}
  static String getVBankName()  {return _preferences?.getString('bank_nam')??"";}

  static Future saveWalletBalance(String walletBalance) async {_preferences?.setString('walletBalance', walletBalance);}
  static String getWalletBalance()  {return _preferences?.getString('walletBalance')??"";}

  //Switch for activating or enabling face/touch ID
  static Future<bool?> saveSwitchState(bool value) async {return _preferences?.setBool("switchStateTouchID", value);}
  static bool? getSwitchValuesForTouchID()  {return _preferences?.getBool("switchStateTouchID");}

  //hide and show wallet balance
  static bool? getSwitchValuesForWalletBalance()  {return _preferences?.getBool("switchState");}



  static Future<bool>getVisitingFlag() async{
    bool alreadyVisited=_preferences?.getBool("alreadyvisited") ?? false;
    return alreadyVisited;
  }
  static setVisitingFlag() async{return _preferences?.setBool("alreadyvisited", true);}

  static clearSharedPref() async{await _preferences?.remove("alreadyvisited");}

  ///Danger zone
  static deleteAllSharedPref() async{await _preferences?.clear();}

}