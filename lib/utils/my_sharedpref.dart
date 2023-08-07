import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference{
  static SharedPreferences ? _preferences;

  static Future init() async =>_preferences=await SharedPreferences.getInstance();
  static Future saveEmail(String email) async {_preferences?.setString('email', email);}
  static String getEmail()  {return _preferences?.getString('email')??"";}

  static Future saveToken(String token) async {_preferences?.setString('token', token);}
  static String getToken()  {return _preferences?.getString('token')??"";}
  static Future saveUId(int uid) async {_preferences?.setInt('uid', uid);}
  static int getUId()  {return _preferences?.getInt('uid')??0;}
  static Future saveFname(String name) async {_preferences?.setString('name', name);}
  static String getFname()  {return _preferences?.getString('name')??"";}

  static Future saveLastname(String last_name) async {_preferences?.setString('last_name', last_name);}
  static String getLastname()  {return _preferences?.getString('last_name')??"";}

  static Future savePhoneNumber(String phone_numb) async {_preferences?.setString('phone_numb', phone_numb);}
  static String getPhoneNumber()  {return _preferences?.getString('phone_numb')??"";}

  static Future saveWallet(String wallet_bal) async {_preferences?.setString('wallet_bal', wallet_bal);}
  static String getWalletr()  {return _preferences?.getString('wallet_bal')??"0";}




  static Future<bool>getVisitingFlag() async{
    bool alreadyVisited=_preferences?.getBool("alreadyvisited") ?? false;
    return alreadyVisited;
  }
  static setVisitingFlag() async{return _preferences?.setBool("alreadyvisited", true);}

  static clearSharedPref() async{await _preferences?.remove("alreadyvisited");}

  ///Danger zone
  static deleteAllSharedPref() async{await _preferences?.clear();}

}