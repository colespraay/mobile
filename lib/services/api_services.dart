
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:http_parser/http_parser.dart';
import 'package:spraay/components/constant.dart';
import 'package:spraay/components/reusable_widget.dart';
import 'package:spraay/models/category_list_model.dart';
import 'package:spraay/models/current_user.dart';
import 'package:spraay/models/events_models.dart';
import 'package:spraay/models/join_event_model.dart';
import 'package:spraay/models/list_of_banks_model.dart';
import 'package:spraay/models/login_response.dart';
import 'package:spraay/models/ongoing_event_model.dart';
import 'package:spraay/models/recent_recipient_models.dart';
import 'package:spraay/models/recipient_model.dart';
import 'package:spraay/models/registered_user_model.dart';
import 'package:spraay/models/transaction_models.dart';
import 'package:spraay/models/user_profile.dart';
import 'package:spraay/models/user_saved_bank_model.dart';
import 'package:spraay/services/api_response.dart';
class ApiServices{


  Future<Map<String, dynamic>> logIn(String phoneNumber, String password)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.post(Uri.parse("$url/auth/login/phone-number"), body:{"phoneNumber":phoneNumber, "password":password},
          headers: {"Accept":"application/json"}).timeout(Duration(seconds: 30));
      // int statusCode = response.statusCode;
      log("ResbodyMM==${response.body}");
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

        result["walletBalance"]=loginResponse.data?.user?.walletBalance??0;



        result["virtualAccountName"]=loginResponse.data?.user?.virtualAccountName??"";
        result["virtualAccountNumber"]=loginResponse.data?.user?.virtualAccountNumber??"";




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
    log("registerresponse==${response.body}");
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

Future<Map<String, dynamic>> registerVerifyCode(String uniqueVerificationCode, String token)async{
  Map<String, dynamic> result = {};
  try{
    var response=await http.get(Uri.parse("$url/user/verification/verify-signup-code/$uniqueVerificationCode"),
        headers: {"Accept":"application/json", "Authorization": "Bearer $token"}).timeout(Duration(seconds: 30));
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
      log("messagedddre=${response.body}");

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

  Future<Map<String, dynamic>> initiateForgotPasswordEmail(String emailAddress)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.get(Uri.parse("$url/user/verification/initiate-forgot-password-flow/$emailAddress"),
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

  Future<Map<String, dynamic>> initiateForgotPasswordPhoneNumber(String phoneNumber)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.get(Uri.parse("$url/user/verification/resend-otp-code/phone/$phoneNumber"),
          headers: {"Accept":"application/json"}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      log("messageresponse=${response.body}");
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



  Future<Map<String, dynamic>> verifyOtp(String uniqueVerificationCode)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.get(Uri.parse("$url/user/verification/verify-otp/$uniqueVerificationCode"),
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

  Future<Map<String, dynamic>> changeForgotPassword(String uniqueVerificationCode, String newPassword)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.post(Uri.parse("$url/user/verification/change-password"),
          body: {"uniqueVerificationCode": uniqueVerificationCode, "newPassword": newPassword},
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

  Future<Map<String, dynamic>> changePassword(String token ,String currentPassword, String newPassword)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.post(Uri.parse("$url/user/change-account-password"),
          body: {"currentPassword": currentPassword, "newPassword": newPassword},
          headers:{"Accept":"application/json", "Authorization": "Bearer $token"}).timeout(Duration(seconds: 30));
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


  Future<ApiResponse<UserResponse>> userDetailApi(String mytoken, String uid){
    return http.get(Uri.parse("$url/user/$uid"),
        headers:{'accept' : 'application/json','Authorization' : 'Bearer $mytoken'}).then((response){
      if(response.statusCode ==200){
        // final body=json.decode(response.body);
        final note1=UserResponse.fromJson(jsonDecode(response.body));
        return ApiResponse<UserResponse>(data: note1);
      }else{
        return ApiResponse<UserResponse>( error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e){
      return ApiResponse<UserResponse>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  Future<Map<String, dynamic>> updateProfile(String email, String userId, String firstName, String lastName, String gender)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.patch(Uri.parse("$url/user"),
          body: {"email": email, "userId": userId, "firstName": firstName, "lastName": lastName, "gender": gender},
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

  Future<Map<String, dynamic>> notificationSettingsApi( String userId,String title, bool boolValue)async{
    Map<String, dynamic> result = {};
    try{

      Map<String, dynamic>  data = {
        "userId": userId,
      };

      if (title=="push") {
        data["allowPushNotifications"] = boolValue;
      }
      if (title=="sms") {
        data["allowSmsNotifications"] = boolValue;
      }
      if (title=="email") {
        data["allowEmailNotifications"] = boolValue;
      }

      // log("datadata=${data}");

      var response=await http.patch(Uri.parse("$url/user"),
          body: jsonEncode(data),
          headers: {"Accept":"application/json",'Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
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
    catch(e){
      print("errror=${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;}
    return result;
  }

  Future<Map<String, dynamic>> uploadFile(File image, String filename)async{
    Map<String, dynamic> result = {};
    ///MultiPart request
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$url/upload-files"),);
      Map<String, String> headers = { "Accept": "application/json", 'Content-Type': 'application/json; charset=UTF-8',};

      request.files.add(http.MultipartFile('files[]', image.readAsBytes().asStream(), image.lengthSync(), filename: filename, contentType: MediaType('image', 'jpeg'),),);
      request.headers.addAll(headers);
      // request.fields.addAll({"user_id": user_id,"title":title,"body":body,"publish":status});


      var res = await request.send();
      final response = await http.Response.fromStream(res);
      // print("responsecode=${response.statusCode}");
      // print("bodyresponseImags=${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        result["error"] = false;
        var jsonResponse = convert.jsonDecode(response.body);
        result['message'] = jsonResponse['message']; //save data gotten from SharedPref
        result['file_url'] = jsonResponse['data'][0]; //save data gotten from SharedPref

      } else {
        result['message'] = "Something went wrong";
        result['error'] = true;
      }
    }catch(error){
      print("errorerror==$error");
      result["message"] = "Error in network connection";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> uploadImageUrl(String profileImageUrl, String userId,)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.patch(Uri.parse("$url/user"),
          body: {"profileImageUrl": profileImageUrl, "userId": userId},
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



  Future<ApiResponse<CategoryListModel>> categoryListApi(String mytoken,){
    return http.get(Uri.parse("$url/event/get/event-categories"),
        headers:{'accept' : 'application/json','Authorization' : 'Bearer $mytoken'}).then((response){
      if(response.statusCode ==200){
        // final body=json.decode(response.body);
        final note1=CategoryListModel.fromJson(jsonDecode(response.body));
        return ApiResponse<CategoryListModel>(data: note1);
      }else{
        return ApiResponse<CategoryListModel>( error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e){
      return ApiResponse<CategoryListModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  Future<Map<String, dynamic>> createEvent(String eventName, String eventDescription,
      String venue, String eventDate, String time, String category, String eventCoverImage, String mytoken, String longitude, String latitude)async{
    Map<String, dynamic> result = {};


    try{
      var response=await http.post(Uri.parse("$url/event"),
          body: jsonEncode({"eventName": eventName, "eventDescription": eventDescription, "venue":venue, "eventDate":eventDate,"time":time,"category":category,
          "eventCoverImage": eventCoverImage,"eventGeoCoordinates": {"longitude": longitude, "latitude": latitude} }),
          headers: {"Accept":"application/json",'Authorization' : 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      log("responseData=${response.body}");
      if (statusCode == 200 || statusCode==201) {
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"] =jsonResponse["message"];
        result["id"] =jsonResponse["data"]["id"];
        result["eventCode"] =jsonResponse["data"]["eventCode"];
        result["qrCodeForEvent"] =jsonResponse["data"]["qrCodeForEvent"];
        result["eventName"] =jsonResponse["data"]["eventName"];

        result["eventDescription"] =jsonResponse["data"]["eventDescription"];
        result["eventDate"] =jsonResponse["data"]["eventDate"];
        result["time"] =jsonResponse["data"]["time"];
        result["venue"] =jsonResponse["data"]["venue"];

        result["category"] =jsonResponse["data"]["category"];
        result["eventCoverImage"] =jsonResponse["data"]["eventCoverImage"];

        result["latitude"] =jsonResponse["data"]["eventGeoCoordinates"]["latitude"];
        result["longitude"] =jsonResponse["data"]["eventGeoCoordinates"]["longitude"];


        result['error'] = false;
      }
      else{
        log("responseDataerrr=${response.body}");

        var jsonResponse=convert.jsonDecode(response.body);
        result["message"]= jsonResponse["message"];
        result['error'] = true;
      }

    }
    on HttpException{result["message"] = "Error in network connection"; result['error'] = true;}
    on SocketException{result["message"] = "Error in network connection";result['error'] = true;}
    on FormatException{result["message"] = "invalid format";result['error'] = true;}
    catch(e){
      log("eeeeerr=${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }


  Future<ApiResponse<RegisteredUserModel>> registeredUserListApi(String mytoken,){
    return http.get(Uri.parse("$url/user?role=CUSTOMER"),
        headers:{'accept' : 'application/json','Authorization' : 'Bearer $mytoken'}).then((response){
      if(response.statusCode ==200){
        // final body=json.decode(response.body);
        final note1=RegisteredUserModel.fromJson(jsonDecode(response.body));
        return ApiResponse<RegisteredUserModel>(data: note1);
      }else{
        return ApiResponse<RegisteredUserModel>( error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e){
      return ApiResponse<RegisteredUserModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }


  Future<ApiResponse<RecentRecipientModel>> recentRecipientApi(String mytoken,){
    return http.get(Uri.parse("$url/transaction/find/recent-recipients"),
        headers:{'accept' : 'application/json','Authorization' : 'Bearer $mytoken'}).then((response){
      if(response.statusCode ==200){
        // final body=json.decode(response.body);
        final note1=RecentRecipientModel.fromJson(jsonDecode(response.body));
        return ApiResponse<RecentRecipientModel>(data: note1);
      }else{
        return ApiResponse<RecentRecipientModel>( error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e){
      return ApiResponse<RecentRecipientModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }


  Future<Map<String, dynamic>> sendInvite(String eventId,String mytoken, List<String> userIds)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.post(Uri.parse("$url/event-invite"),
          body: jsonEncode({"eventId": eventId, "userIds": userIds,}),
          headers: {"Accept":"application/json",'Authorization' : 'Bearer $mytoken','Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      log("ressssp=${response.body}");
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
    catch(e){
      print("object${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }

  Future<Map<String, dynamic>> sendGift(String amount,String mytoken, String receiverTag, String transactionPin)async{
    Map<String, dynamic> result = {};
    print("receiverTag=$receiverTag");
    try{
      var response=await http.post(Uri.parse("$url/gifting/send-gift"),
          body: jsonEncode({"amount": amount, "receiverTag": receiverTag, "transactionPin": transactionPin}),
          headers: {"Accept":"application/json",'Authorization' : 'Bearer $mytoken','Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      log("ressssp=${response.body}");
      if (statusCode == 200 || statusCode==201) {
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"] =jsonResponse["message"];
        result["dateCreated"] =jsonResponse['data']["dateCreated"];
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
    catch(e){
      print("object${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }


  Future<Map<String, dynamic>> userByTag(String userTag,String mytoken)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.get(Uri.parse("$url/user/find-by-tag/$userTag"),
          headers: {"Accept":"application/json",'Authorization' : 'Bearer $mytoken','Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      log("ressssp=${response.body}");
      if (statusCode == 200 || statusCode==201) {
        var jsonResponse=convert.jsonDecode(response.body);
        // result["message"] =jsonResponse["message"];
        result["firstName"] =jsonResponse['data']['firstName'];
        result["lastName"] =jsonResponse['data']['lastName'];
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
    catch(e){
      print("object${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }


  Future<Map<String, dynamic>> editEvent(String mytoken ,String eventName, String eventDescription, String venue, String eventDate, String time, String category,
      String eventCoverImage, String eventId, String longitude, String latitude)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.patch(Uri.parse("$url/event"),
          body: jsonEncode({"eventName": eventName, "eventDescription": eventDescription, "venue": venue, "eventDate": eventDate,
            "time": time, "category": category,"eventCoverImage":eventCoverImage, "eventId": eventId,"eventStatus": "UPCOMING","eventGeoCoordinates": {"longitude": longitude, "latitude": latitude},
            "status": true}),
          headers: {"Accept":"application/json", 'Authorization' : 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
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
    catch(e){
      print("errrr=${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }


  Future<ApiResponse<EventsModel>> eventsList(String mytoken, String userId){
    return http.get(Uri.parse("$url/event?userId=$userId"),
        headers:{'accept' : 'application/json','Authorization' : 'Bearer $mytoken'}).then((response){
      if(response.statusCode ==200){
        // final body=json.decode(response.body);
        final note1=EventsModel.fromJson(jsonDecode(response.body));
        return ApiResponse<EventsModel>(data: note1);
      }else{
        return ApiResponse<EventsModel>( error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e){
      if(e.toString().contains("SocketException")){
        return ApiResponse<EventsModel>(error: true, errorMessage: 'Error in network connection');

      }else{
        return ApiResponse<EventsModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');

      }
    });
  }


  Future<ApiResponse<OngoingEventModel>> ongoingEventsList(String mytoken){
    return http.get(Uri.parse("$url/event/ongoing/events-for-current-user"),
        headers:{'accept' : 'application/json','Authorization' : 'Bearer $mytoken'}).then((response){
      if(response.statusCode ==200){
        // final body=json.decode(response.body);
        final note1=OngoingEventModel.fromJson(jsonDecode(response.body));
        return ApiResponse<OngoingEventModel>(data: note1);
      }else{
        return ApiResponse<OngoingEventModel>( error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e){
      if(e.toString().contains("SocketException")){
        return ApiResponse<OngoingEventModel>(error: true, errorMessage: 'Error in network connection');

      }else{
        return ApiResponse<OngoingEventModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');

      }
    });
  }

  Future<ApiResponse<OngoingEventModel>> pastEventsList(String mytoken){
    return http.get(Uri.parse("$url/event/past/events-for-current-user"),
        headers:{'accept' : 'application/json','Authorization' : 'Bearer $mytoken'}).then((response){
      if(response.statusCode ==200){
        // final body=json.decode(response.body);
        final note1=OngoingEventModel.fromJson(jsonDecode(response.body));
        return ApiResponse<OngoingEventModel>(data: note1);
      }else{
        return ApiResponse<OngoingEventModel>( error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e){
      if(e.toString().contains("SocketException")){
        return ApiResponse<OngoingEventModel>(error: true, errorMessage: 'Error in network connection');

      }else{
        return ApiResponse<OngoingEventModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');

      }
    });
  }


  Future<ApiResponse<CurrentUserModel>> currentUser(String mytoken){
    return http.get(Uri.parse("$url/event/events-for-current-user"),
        headers:{'accept' : 'application/json','Authorization' : 'Bearer $mytoken'}).then((response){
      if(response.statusCode ==200){
        // final body=json.decode(response.body);
        final note1=CurrentUserModel.fromJson(jsonDecode(response.body));
        return ApiResponse<CurrentUserModel>(data: note1);
      }else{
        return ApiResponse<CurrentUserModel>( error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e){
      if(e.toString().contains("SocketException")){
        return ApiResponse<CurrentUserModel>(error: true, errorMessage: 'Error in network connection');

      }else{
        return ApiResponse<CurrentUserModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');

      }
    });
  }

  Future<Map<String, dynamic>> acceptOrRejectEvent(String eventId,String mytoken, String status)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.post(Uri.parse("$url/event-rsvp"),
          body: jsonEncode({"eventId": eventId, "status": status}),
          headers: {"Accept":"application/json",'Authorization' : 'Bearer $mytoken','Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      log("ressssp=${response.body}");
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
    catch(e){
      print("object${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }

  Future<Map<String, dynamic>> sprayEvent(String eventId,String mytoken, String amount, String transactionPin)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.post(Uri.parse("$url/event-spraay"),
          body: jsonEncode({"amount": amount, "eventId": eventId, "transactionPin":transactionPin}),
          headers: {"Accept":"application/json",'Authorization' : 'Bearer $mytoken','Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      log("ressssp=${response.body}");
      if (statusCode == 200 || statusCode==201) {
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"] =jsonResponse["message"];
        result["amount"] =jsonResponse["data"]["amount"];
        result["dateCreated"] =jsonResponse["data"]["dateCreated"];
        result["eventCode"] =jsonResponse["eventCode"];
        result["transactionReference"] =jsonResponse["transactionReference"];
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
    catch(e){
      print("object${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }

  Future<Map<String, dynamic>> transactionPinApi(String mytoken, String transactionPin)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.get(Uri.parse("$url/user/verify/transaction-pin/$transactionPin"),
          headers: {"Accept":"application/json",'Authorization' : 'Bearer $mytoken','Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      log("ressssp=${response.body}");
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
    catch(e){
      print("object${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }

  Future<Map<String, dynamic>> userSaveBankApi(String mytoken, String bankCode, String accountNumber)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.post(Uri.parse("$url/user-account"),
          body: jsonEncode({"bankCode": bankCode, "accountNumber": accountNumber}),

          headers:  {"Accept":"application/json",'Authorization' : 'Bearer $mytoken','Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      log("ressssp=${response.body}");
      if (statusCode == 200 || statusCode==201) {
        var jsonResponse=convert.jsonDecode(response.body);
        result["accountName"] =jsonResponse["data"]["accountName"];
        result["accountNumber"] =jsonResponse["data"]["accountNumber"];
        result["bankCode"] =jsonResponse["data"]["bankCode"];
        result["bankName"] =jsonResponse["data"]["bankName"];
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
    catch(e){
      print("object${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }


  Future<Map<String, dynamic>> withdrawalApi(String mytoken, String bankName, String accountNumber, String bankCode, String transactionPin, String amount)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.post(Uri.parse("$url/withdrawal"),
          body: jsonEncode({"bankName": bankName, "bankCode": bankCode, "accountNumber": accountNumber, "transactionPin": transactionPin, "amount": amount}),

          headers:  {"Accept":"application/json",'Authorization' : 'Bearer $mytoken','Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;



      if (statusCode == 200 || statusCode==201) {
        var jsonResponse=convert.jsonDecode(response.body);
        log("messagewithdrawalApi==${jsonResponse}");



        result["message"]= jsonResponse["message"];
    result["transactionId"]= jsonResponse["data"]["transactionId"];
    result["amount"]= jsonResponse["data"]["amount"];
    result["type"]= jsonResponse["data"]["transaction"]["type"];
    result["dateCreated"]= jsonResponse["data"]["transaction"]["dateCreated"];
    result["reference"]= jsonResponse["data"]["transaction"]["reference"];



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
    catch(e){
      print("object${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }



  Future<Map<String, dynamic>> checkbalanceBeforeWithdrawingApi(String mytoken, String amount)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.get(Uri.parse("$url/user/account/check-balance-before-debit/$amount"),
          headers: {"Accept":"application/json",'Authorization' : 'Bearer $mytoken','Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;
      log("ressssp=${response.body}");
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
    catch(e){
      print("object${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }



  Future<ApiResponse<JoinEventModel>> joinEvent(String mytoken, String eventCode){
    return http.get(Uri.parse("$url/event/by-code/$eventCode"),
        headers:{'accept' : 'application/json','Authorization' : 'Bearer $mytoken'}).then((response){
      if(response.statusCode ==200){
        // final body=json.decode(response.body);
        final note1=JoinEventModel.fromJson(jsonDecode(response.body));
        return ApiResponse<JoinEventModel>(data: note1);
      }else{
        return ApiResponse<JoinEventModel>( error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e){
      if(e.toString().contains("SocketException")){
        return ApiResponse<JoinEventModel>(error: true, errorMessage: 'Error in network connection');

      }else{
        return ApiResponse<JoinEventModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');

      }
    });
  }



  Future<ApiResponse<TransactionModels>> transactionListApi(String mytoken, String userId){
    return http.get(Uri.parse("$url/transaction?userId=$userId"),
        headers:{'accept' : 'application/json','Authorization' : 'Bearer $mytoken'}).then((response){
      if(response.statusCode ==200){
        // final body=json.decode(response.body);
        final note1=TransactionModels.fromJson(jsonDecode(response.body));
        return ApiResponse<TransactionModels>(data: note1);
      }else{
        return ApiResponse<TransactionModels>( error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e){
      if(e.toString().contains("SocketException")){
        return ApiResponse<TransactionModels>(error: true, errorMessage: 'Error in network connection');

      }else{
        return ApiResponse<TransactionModels>(error: true, errorMessage: 'Something went wrong ${e.toString()}');

      }
    });
  }


  Future<ApiResponse<ListOfBankModel>> listOfBankApi(String mytoken){
    return http.get(Uri.parse("$url/wallet/list-of-banks"),
        headers:{'accept' : 'application/json','Authorization' : 'Bearer $mytoken'}).then((response){
      if(response.statusCode ==200){
        // final body=json.decode(response.body);
        final note1=ListOfBankModel.fromJson(jsonDecode(response.body));
        return ApiResponse<ListOfBankModel>(data: note1);
      }else{
        return ApiResponse<ListOfBankModel>( error: true, errorMessage: jsonDecode(response.body)['message']);
      }
    }).catchError((e){
      if(e.toString().contains("SocketException")){
        return ApiResponse<ListOfBankModel>(error: true, errorMessage: 'Error in network connection');

      }else{
        return ApiResponse<ListOfBankModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');

      }
    });
  }


  Future<ApiResponse<UserSavedBankModels>> savedBanksInfoApi(String mytoken){
    return http.get(Uri.parse("$url/user-account"),
        headers:{'accept' : 'application/json','Authorization' : 'Bearer $mytoken'}).then((response){
      if(response.statusCode ==200){
        // final body=json.decode(response.body);
        final note1=UserSavedBankModels.fromJson(jsonDecode(response.body));
        return ApiResponse<UserSavedBankModels>(data: note1);
      }else{
        return ApiResponse<UserSavedBankModels>( error: true, errorMessage: jsonDecode(response.body)['message']);
      }
    }).catchError((e){
      if(e.toString().contains("SocketException")){
        return ApiResponse<UserSavedBankModels>(error: true, errorMessage: 'Error in network connection');

      }else{
        return ApiResponse<UserSavedBankModels>(error: true, errorMessage: 'Something went wrong ${e.toString()}');

      }
    });
  }


  Future<Map<String, dynamic>> downloadSingleTransaction(String mytoken, String transactionListID)async{
    Map<String, dynamic> result = {};
    try{
      var response=await http.get(Uri.parse("https://spraay-api-577f3dc0a0fe.herokuapp.com/transaction/download-receipt/$transactionListID"),
          headers: {"Accept":"application/json",'Authorization' : 'Bearer $mytoken','Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print("statusCodestatusCode11=${statusCode}");
      log("ressssp=${response.body}");
      // final bytes = response.bodyBytes;
      // await DocumentFileSavePlus().saveFile(bytes, "spray.pdf", "appliation/pdf").then((valueee){
      //
      //   toastMessage("Filed downloaded");
      // });


      if (statusCode == 200 || statusCode==201) {
        result["bytes"] =response.bodyBytes;
        result['error'] = false;
      }
      else{
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"]= jsonResponse["message"];
        result['error'] = true;
      }

    }
    catch(e){
      print("objecteeeroo${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }


  Future<Map<String, dynamic>> downloadSOA(String mytoken, String userId, String startDate, String endDate)async{
    Map<String, dynamic> result = {};

    try{

      var response=await http.get(Uri.parse("$url/transaction/export-soa?startDate=$startDate&endDate=$endDate"),
          headers: {"Accept":"application/json",'Authorization' : 'Bearer $mytoken','Content-Type': 'application/json'}).timeout(Duration(seconds: 30));
      int statusCode = response.statusCode;

      print("statusCodestatusCode11=${statusCode}");
      log("ressssp=${response.body}");
      // final bytes = response.bodyBytes;
      // await DocumentFileSavePlus().saveFile(bytes, "spray.pdf", "appliation/pdf").then((valueee){
      //
      //   toastMessage("Filed downloaded");
      // });


      if (statusCode == 200 || statusCode==201) {
        result["bytes"] =response.bodyBytes;
        result['error'] = false;
      }
      else{
        var jsonResponse=convert.jsonDecode(response.body);
        result["message"]= jsonResponse["message"];
        result['error'] = true;
      }

    }
    catch(e){
      print("objecteeeroo${e.toString()}");
      result["message"] = "Something went wrong";result['error'] = true;}
    return result;
  }



}
