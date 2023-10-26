import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{

  final FlutterSecureStorage storage =  const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true,));

  Future savePassword(String password) async {await storage.write(key: "password", value: password);}

 Future<String> getPassword() async {
    String value = await storage.read(key: "password") ?? "";
    return value;
  }

  Future saveVn(String vn) async {await storage.write(key: "bvn", value: vn);}

  Future<String> getVn() async {
    String value = await storage.read(key: "bvn") ?? "";
    return value;
  }

}