
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:spraay/components/constant.dart';
import 'package:spraay/models/login_response.dart';
class ApiServices{


  Future<Map<String, dynamic>> logIn(String email, String password)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.post(Uri.parse("$url/auth/login"), body:{"email":email, "password":password},
          headers: {"Accept":"application/json"}).timeout(Duration(seconds: 30));
      // int statusCode = response.statusCode;
      // log("ResbodyMM==${response.body}");
      // print("Resbody statusCode==${response.statusCode}");

      var jsonResponse=convert.jsonDecode(response.body);

      if (jsonResponse["code"] == 200) {

        var loginResponse=LogoinResponse.fromJson(jsonResponse);
        result["id"] =loginResponse.data?.userId??"";
        result["firstname"] =loginResponse.data?.user?.firstName??"";
        result["lastname"]=loginResponse.data?.user?.lastName??"";
        result["email"]=loginResponse.data?.user?.email??"";
        result["phone"]=loginResponse.data?.user?.phoneNumber??"";
        result["token"]=loginResponse.data?.token??"";
        result["deviceId"]=loginResponse.data?.user?.deviceId??"";
        result["profileImageUrl"]=loginResponse.data?.user?.profileImageUrl??"";
        result["virtualAccountName"]=loginResponse.data?.user?.virtualAccountName??"";
        result["virtualAccountNumber"]=loginResponse.data?.user?.virtualAccountNumber??"";
        result["bankName"]=loginResponse.data?.user?.bankName??"";
        result["gender"]=loginResponse.data?.user?.gender??"";
        result["dob"]=loginResponse.data?.user?.dob??"";
        result["userTag"]=loginResponse.data?.user?.userTag??"";
        result["allowPushNotifications"]=loginResponse.data?.user?.allowPushNotifications??false;
        result["allowSmsNotifications"]=loginResponse.data?.user?.allowSmsNotifications??false;
        result["allowEmailNotifications"]=loginResponse.data?.user?.allowEmailNotifications??false;
        result["displayWalletBalance"]=loginResponse.data?.user?.displayWalletBalance??false;
        result["enableFaceId"]=loginResponse.data?.user?.enableFaceId??false;


        result['error'] = false;
      }
      else{
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"]= jsonResponse["message"];
        result['error'] = true;
      }

    }
    on HttpException{result["message"] = "Error in network connection"; result['error'] = true;}
    on SocketException{result["message"] = "Error in network connection";result['error'] = true;}
    on FormatException{result["message"] = "invalid format";result['error'] = true;}
    catch(e){result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }


  Future<Map<String, dynamic>> register(String password, String phoneNumber, String deviceId)async{
  Map<String, dynamic> result = {};
  try{
    var response=await http.post(Uri.parse("$url/user/sign-up/phone-number"), body: {"password":password, "phoneNumber":phoneNumber,"deviceId":deviceId},
        headers: {"Accept":"application/json"}).timeout(Duration(seconds: 30));
    int statusCode = response.statusCode;
    if (statusCode == 200 || statusCode == 201) {
      var jsonResponse=convert.jsonDecode(response.body);
      result["message"] =jsonResponse["message"];
      result["userId"] =jsonResponse["data"]["userId"];
      result["token"] =jsonResponse["data"]["token"];
      result["phoneNumber"] =jsonResponse["data"]["user"]["phoneNumber"];

      result['error'] = false;
    }
    else{
      var jsonResponse=convert.jsonDecode(response.body);
      result["message"]= jsonResponse["message"];
      result['error'] = true;
    }

  }
  on HttpException{result["message"] = "Error in network connection"; result['error'] = true;}
  on SocketException{result["message"] = "Error in network connection";result['error'] = true;}
  on FormatException{result["message"] = "invalid format";result['error'] = true;}
  catch(e){result["message"] = "Something went wrong";result['error'] = true;}
  return result;
}

Future<Map<String, dynamic>> registerVerifyCode(String uniqueVerificationCode)async{
  Map<String, dynamic> result = {};
  try{
    var response=await http.get(Uri.parse("$url/user/verification/verify-signup-code/$uniqueVerificationCode"),
        headers: {"Accept":"application/json"}).timeout(Duration(seconds: 30));
    int statusCode = response.statusCode;
    if (statusCode == 200 || statusCode==201) {
      var jsonResponse=convert.jsonDecode(response.body);
      result["message"] =jsonResponse["message"];
      result['error'] = false;
    }
    else{
      var jsonResponse=convert.jsonDecode(response.body);
      result["message"]= jsonResponse["message"];
      result['error'] = true;
    }

  }
  on HttpException{result["message"] = "Error in network connection"; result['error'] = true;}
  on SocketException{result["message"] = "Error in network connection";result['error'] = true;}
  on FormatException{result["message"] = "invalid format";result['error'] = true;}
  catch(e){result["message"] = "Something went wrong";result['error'] = true;}
  return result;
}

  Future<Map<String, dynamic>> resendOTPCode(String userID)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.get(Uri.parse("$url/user/resend-otp-code/$userID"),
          headers: {"Accept":"application/json"}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode==201) {
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"] =jsonResponse["message"];
        result['error'] = false;
      }
      else{
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"]= jsonResponse["message"];
        result['error'] = true;
      }

    }
    on HttpException{result["message"] = "Error in network connection"; result['error'] = true;}
    on SocketException{result["message"] = "Error in network connection";result['error'] = true;}
    on FormatException{result["message"] = "invalid format";result['error'] = true;}
    catch(e){result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }

  Future<Map<String, dynamic>> tellUsAboutYourself(String email, String userId, String firstName, String lastName, String gender, String dob)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.patch(Uri.parse("$url/user"),
          body: {"email": email, "userId": userId, "firstName": firstName, "lastName": lastName, "gender": gender, "dob": dob,},
          headers: {"Accept":"application/json"}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode==201) {
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"] =jsonResponse["message"];
        result['error'] = false;
      }
      else{
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"]= jsonResponse["message"];
        result['error'] = true;
      }

    }
    on HttpException{result["message"] = "Error in network connection"; result['error'] = true;}
    on SocketException{result["message"] = "Error in network connection";result['error'] = true;}
    on FormatException{result["message"] = "invalid format";result['error'] = true;}
    catch(e){result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }


  Future<Map<String, dynamic>> tellUsAboutYourselfTag(String userTag, String userId)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.patch(Uri.parse("$url/user"),
          body: {"userTag": userTag, "userId": userId},
          headers: {"Accept":"application/json"}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode==201) {
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"] =jsonResponse["message"];
        result['error'] = false;
      }
      else{
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"]= jsonResponse["message"];
        result['error'] = true;
      }

    }
    on HttpException{result["message"] = "Error in network connection"; result['error'] = true;}
    on SocketException{result["message"] = "Error in network connection";result['error'] = true;}
    on FormatException{result["message"] = "invalid format";result['error'] = true;}
    catch(e){result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }

  Future<Map<String, dynamic>> createTransactionPin(String transactionPin, String userId)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.patch(Uri.parse("$url/user"),
          body: {"transactionPin": transactionPin, "userId": userId},
          headers: {"Accept":"application/json"}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode==201) {
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"] =jsonResponse["message"];
        result['error'] = false;
      }
      else{
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"]= jsonResponse["message"];
        result['error'] = true;
      }

    }
    on HttpException{result["message"] = "Error in network connection"; result['error'] = true;}
    on SocketException{result["message"] = "Error in network connection";result['error'] = true;}
    on FormatException{result["message"] = "invalid format";result['error'] = true;}
    catch(e){result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }




}
