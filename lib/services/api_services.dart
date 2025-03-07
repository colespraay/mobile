import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:spraay/models/airtime_topup_model.dart';
import 'package:spraay/models/betting_plan_model.dart';
import 'package:spraay/models/cable_tv_model.dart';
import 'package:spraay/models/category_list_model.dart';
import 'package:spraay/models/current_user.dart';
import 'package:spraay/models/data_model.dart';
import 'package:spraay/models/events_models.dart';
import 'package:spraay/models/game_model_data.dart';
import 'package:spraay/models/graph_history_model.dart';
import 'package:spraay/models/join_event_model.dart';
import 'package:spraay/models/list_of_banks_model.dart';
import 'package:spraay/models/login_response.dart';
import 'package:spraay/models/new_data_plan.dart';
import 'package:spraay/models/notification_model.dart';
import 'package:spraay/models/ongoing_event_model.dart';
import 'package:spraay/models/pre_post_model.dart';
import 'package:spraay/models/recent_recipient_models.dart';
import 'package:spraay/models/registered_user_model.dart';
import 'package:spraay/models/transaction_models.dart';
import 'package:spraay/models/user_name_with_phone_contact_model.dart';
import 'package:spraay/models/user_profile.dart';
import 'package:spraay/models/user_saved_bank_model.dart';
import 'package:spraay/services/api_response.dart';

class ApiServices {
  String url = "https://spraay-api-577f3dc0a0fe.herokuapp.com";
  // String url="https://admin-test-app-527853a95e08.herokuapp.com";
  Future<Map<String, dynamic>> logIn(String phoneNumber, String password, String deviceId) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/auth/login/phone-number"),
          body: {"phoneNumber": phoneNumber, "password": password, "deviceId": deviceId}, headers: {"Accept": "application/json"}).timeout(const Duration(seconds: 30));
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse["code"] == 200) {
        var loginResponse = LogoinResponse.fromJson(jsonResponse);
        result["id"] = loginResponse.data?.userId ?? "";
        result["firstname"] = loginResponse.data?.user?.firstName ?? "";
        result["lastname"] = loginResponse.data?.user?.lastName ?? "";
        result["email"] = loginResponse.data?.user?.email ?? "";
        result["phone"] = loginResponse.data?.user?.phoneNumber ?? "";
        result["token"] = loginResponse.data?.token ?? "";
        result["deviceId"] = loginResponse.data?.user?.deviceId ?? "";
        result["profileImageUrl"] = loginResponse.data?.user?.profileImageUrl ?? "";
        result["virtualAccountName"] = loginResponse.data?.user?.virtualAccountName ?? "";
        result["virtualAccountNumber"] = loginResponse.data?.user?.virtualAccountNumber ?? "";
        result["bankName"] = loginResponse.data?.user?.bankName ?? "";
        result["gender"] = loginResponse.data?.user?.gender ?? "";
        result["dob"] = loginResponse.data?.user?.dob ?? "";
        result["userTag"] = loginResponse.data?.user?.userTag ?? "";
        result["allowPushNotifications"] = loginResponse.data?.user?.allowPushNotifications ?? false;
        result["allowSmsNotifications"] = loginResponse.data?.user?.allowSmsNotifications ?? false;
        result["allowEmailNotifications"] = loginResponse.data?.user?.allowEmailNotifications ?? false;
        result["displayWalletBalance"] = loginResponse.data?.user?.displayWalletBalance ?? false;
        result["enableFaceId"] = loginResponse.data?.user?.enableFaceId ?? false;

        result["walletBalance"] = loginResponse.data?.user?.walletBalance ?? 0;
        result["bvn"] = loginResponse.data?.user?.bvn ?? "";
        result["virtualAccountName"] = loginResponse.data?.user?.virtualAccountName ?? "";
        result["virtualAccountNumber"] = loginResponse.data?.user?.virtualAccountNumber ?? "";

        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> register(String password, String phoneNumber, String deviceId) async {
    Map<String, dynamic> result = {};
    print('$password $phoneNumber $deviceId');
    try {
      var response = await http.post(Uri.parse("$url/user/sign-up/phone-number"),
          body: {"password": password, "phoneNumber": phoneNumber, "deviceId": deviceId}, headers: {"Accept": "application/json"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      print(response.body);
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result["userId"] = jsonResponse["data"]["userId"];
        result["token"] = jsonResponse["data"]["token"];
        result["phoneNumber"] = jsonResponse["data"]["user"]["phoneNumber"];

        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> registerVerifyCode(String uniqueVerificationCode, String token) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.get(Uri.parse("$url/user/verification/verify-signup-code/$uniqueVerificationCode"),
          headers: {"Accept": "application/json", "Authorization": "Bearer $token"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> verifyBvnCode(String userId, String bvn, String token) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.patch(Uri.parse("$url/user"), body: {
        "userId": userId,
        "bvn": bvn,
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      }).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> resendOTPCode(String userID) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.get(Uri.parse("$url/user/resend-otp-code/$userID"), headers: {"Accept": "application/json"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> tellUsAboutYourself(String email, String userId, String firstName, String lastName, String gender, String dob) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.patch(Uri.parse("$url/user"), body: {
        "email": email,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "dob": dob,
      }, headers: {
        "Accept": "application/json"
      }).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> tellUsAboutYourselfTag(String userTag, String userId) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.patch(Uri.parse("$url/user"), body: {"userTag": userTag, "userId": userId}, headers: {"Accept": "application/json"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> createTransactionPin(String transactionPin, String userId) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.patch(Uri.parse("$url/user"), body: {"transactionPin": transactionPin, "userId": userId}, headers: {"Accept": "application/json"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> initiateForgotPasswordEmail(String emailAddress) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.get(Uri.parse("$url/user/verification/initiate-forgot-password-flow/$emailAddress"), headers: {"Accept": "application/json"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> initiateForgotPasswordPhoneNumber(String phoneNumber) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.get(Uri.parse("$url/user/verification/resend-otp-code/phone/$phoneNumber"), headers: {"Accept": "application/json"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> verifyOtp(String uniqueVerificationCode) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.get(Uri.parse("$url/user/verification/verify-otp/$uniqueVerificationCode"), headers: {"Accept": "application/json"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> changeForgotPassword(String uniqueVerificationCode, String newPassword) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/user/verification/change-password"),
          body: {"uniqueVerificationCode": uniqueVerificationCode, "newPassword": newPassword}, headers: {"Accept": "application/json"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> changePassword(String token, String currentPassword, String newPassword) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/user/change-account-password"),
          body: {"currentPassword": currentPassword, "newPassword": newPassword}, headers: {"Accept": "application/json", "Authorization": "Bearer $token"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> historySummaryFilter(String token, String filter) async {
    Map<String, dynamic> result = {};
    try {
      var response =
          await http.get(Uri.parse("$url/transaction/history-summary/$filter"), headers: {"Accept": "application/json", "Authorization": "Bearer $token"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["total"] = jsonResponse["total"];
        result["income"] = jsonResponse["income"];
        result["expense"] = jsonResponse["expense"];

        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<ApiResponse<UserResponse>> userDetailApi(String mytoken, String uid) {
    return http.get(Uri.parse("$url/user/$uid"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = UserResponse.fromJson(jsonDecode(response.body));
        return ApiResponse<UserResponse>(data: note1);
      } else {
        return ApiResponse<UserResponse>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      return ApiResponse<UserResponse>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  Future<ApiResponse<AirtimeTopUpModelModel>> airtimeDataTopUpApi(String mytoken) {
    return http.get(Uri.parse("$url/bill/airtime-providers"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = AirtimeTopUpModelModel.fromJson(jsonDecode(response.body));
        return ApiResponse<AirtimeTopUpModelModel>(data: note1);
      } else {
        return ApiResponse<AirtimeTopUpModelModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      return ApiResponse<AirtimeTopUpModelModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  Future<ApiResponse<CableTvModel>> cableTvModelApi(String mytoken) {
    return http.get(Uri.parse("$url/bill/cable-providers"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = CableTvModel.fromJson(jsonDecode(response.body));
        return ApiResponse<CableTvModel>(data: note1);
      } else {
        return ApiResponse<CableTvModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      return ApiResponse<CableTvModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  Future<ApiResponse<CableTvModel>> eletricityProvidersApi(String mytoken) {
    return http.get(Uri.parse("$url/bill/electricity-providers"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = CableTvModel.fromJson(jsonDecode(response.body));
        return ApiResponse<CableTvModel>(data: note1);
      } else {
        return ApiResponse<CableTvModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      return ApiResponse<CableTvModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  //GameModel
  Future<ApiResponse<GameModel>> gameProvidersApi(String mytoken) {
    return http.get(Uri.parse("$url/bill/betting-providers"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = GameModel.fromJson(jsonDecode(response.body));
        return ApiResponse<GameModel>(data: note1);
      } else {
        return ApiResponse<GameModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      return ApiResponse<GameModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  Future<ApiResponse<PreOrPostPaidModel>> prePostApi(String mytoken, String merchantPublicId) {
    return http.get(Uri.parse("$url/bill/merchants/electricity/find-plans/$merchantPublicId"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = PreOrPostPaidModel.fromJson(jsonDecode(response.body));
        return ApiResponse<PreOrPostPaidModel>(data: note1);
      } else {
        return ApiResponse<PreOrPostPaidModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      return ApiResponse<PreOrPostPaidModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  Future<ApiResponse<BettingPlanModel>> bettingPlanApi(String mytoken, String merchantPublicId) {
    return http.get(Uri.parse("$url/bill/merchants/betting/find-plans/$merchantPublicId"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = BettingPlanModel.fromJson(jsonDecode(response.body));
        return ApiResponse<BettingPlanModel>(data: note1);
      } else {
        return ApiResponse<BettingPlanModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      return ApiResponse<BettingPlanModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  Future<ApiResponse<GraphHistoryModel>> graphHistoryApi(String mytoken) {
    return http.get(Uri.parse("$url/transaction/graph/history-summary"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        final note1 = GraphHistoryModel.fromJson(jsonDecode(response.body));
        return ApiResponse<GraphHistoryModel>(data: note1);
      } else {
        return ApiResponse<GraphHistoryModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      return ApiResponse<GraphHistoryModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  Future<Map<String, dynamic>> updateProfile(String email, String userId, String firstName, String lastName, String gender) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.patch(Uri.parse("$url/user"),
          body: {"email": email, "userId": userId, "firstName": firstName, "lastName": lastName, "gender": gender}, headers: {"Accept": "application/json"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> notificationSettingsApi(String userId, String title, bool boolValue) async {
    Map<String, dynamic> result = {};
    try {
      Map<String, dynamic> data = {
        "userId": userId,
      };

      if (title == "push") {
        data["allowPushNotifications"] = boolValue;
      }
      if (title == "sms") {
        data["allowSmsNotifications"] = boolValue;
      }
      if (title == "email") {
        data["allowEmailNotifications"] = boolValue;
      }

      var response = await http.patch(Uri.parse("$url/user"), body: jsonEncode(data), headers: {"Accept": "application/json", 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("errror=${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> uploadFile(File image, String filename) async {
    Map<String, dynamic> result = {};

    ///MultiPart request
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$url/upload-files"),
      );
      Map<String, String> headers = {
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      };

      request.files.add(
        http.MultipartFile(
          'files[]',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: filename,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
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
    } catch (error) {
      print("errorerror==$error");
      result["message"] = "Error in network connection";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> uploadImageUrl(
    String profileImageUrl,
    String userId,
  ) async {
    Map<String, dynamic> result = {};
    try {
      var response =
          await http.patch(Uri.parse("$url/user"), body: {"profileImageUrl": profileImageUrl, "userId": userId}, headers: {"Accept": "application/json"}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<ApiResponse<CategoryListModel>> categoryListApi(
    String mytoken,
  ) {
    return http.get(Uri.parse("$url/event-category?status=true"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = CategoryListModel.fromJson(jsonDecode(response.body));
        return ApiResponse<CategoryListModel>(data: note1);
      } else {
        return ApiResponse<CategoryListModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      return ApiResponse<CategoryListModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  Future<Map<String, dynamic>> createEvent(
      String eventName, String eventDescription, String venue, String eventDate, String time, String category, String eventCoverImage, String mytoken, String longitude, String latitude) async {
    Map<String, dynamic> result = {};

    try {
      var response = await http.post(Uri.parse("$url/event"),
          body: jsonEncode({
            "eventName": eventName,
            "eventDescription": eventDescription,
            "venue": venue,
            "eventDate": eventDate,
            "time": time,
            "eventCategoryId": category,
            "eventCoverImage": eventCoverImage,
            "eventGeoCoordinates": {"longitude": longitude, "latitude": latitude}
          }),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result["id"] = jsonResponse["data"]["id"];
        result["eventCode"] = jsonResponse["data"]["eventCode"];
        result["qrCodeForEvent"] = jsonResponse["data"]["qrCodeForEvent"];
        result["eventName"] = jsonResponse["data"]["eventName"];

        result["eventDescription"] = jsonResponse["data"]["eventDescription"];
        result["eventDate"] = jsonResponse["data"]["eventDate"];
        result["time"] = jsonResponse["data"]["time"];
        result["venue"] = jsonResponse["data"]["venue"];

        result["category"] = jsonResponse["data"]["eventCategory"]["name"];
        result["categoryID"] = jsonResponse["data"]["eventCategory"]["id"];

        result["eventCoverImage"] = jsonResponse["data"]["eventCoverImage"];

        result["latitude"] = jsonResponse["data"]["eventGeoCoordinates"]["latitude"];
        result["longitude"] = jsonResponse["data"]["eventGeoCoordinates"]["longitude"];

        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<ApiResponse<RegisteredUserModel>> registeredUserListApi(
    String mytoken,
  ) {
    return http.get(Uri.parse("$url/user?role=CUSTOMER"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = RegisteredUserModel.fromJson(jsonDecode(response.body));
        return ApiResponse<RegisteredUserModel>(data: note1);
      } else {
        return ApiResponse<RegisteredUserModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      return ApiResponse<RegisteredUserModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  Future<ApiResponse<UserPhoneWithNameContactModel>> userContactApi(String mytoken, List<Map<String, String?>> user_contacts) {
    return http.post(Uri.parse("$url/user/find-contacts/filtered-by-contacts"),
        body: jsonEncode({"contacts": user_contacts}), headers: {'Accept': 'application/json', 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).then((response) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        // final body=json.decode(response.body);
        final note1 = UserPhoneWithNameContactModel.fromJson(jsonDecode(response.body));
        return ApiResponse<UserPhoneWithNameContactModel>(data: note1);
      } else {
        return ApiResponse<UserPhoneWithNameContactModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      return ApiResponse<UserPhoneWithNameContactModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  Future<ApiResponse<RecentRecipientModel>> recentRecipientApi(
    String mytoken,
  ) {
    return http.get(Uri.parse("$url/transaction/find/recent-recipients"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = RecentRecipientModel.fromJson(jsonDecode(response.body));
        return ApiResponse<RecentRecipientModel>(data: note1);
      } else {
        return ApiResponse<RecentRecipientModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      return ApiResponse<RecentRecipientModel>(error: true, errorMessage: 'Something went wrong_${e.toString()}');
    });
  }

  //event-category
  Future<Map<String, dynamic>> sendInvite(String eventId, String mytoken, List<String> userIds) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/event-invite"),
          body: jsonEncode({
            "eventId": eventId,
            "userIds": userIds,
          }),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> deleteAccount(String userIds, String mytoken) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.delete(Uri.parse("$url/user/$userIds"),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;

      log("deleteAccountRespod==${response.body}");
      log("statusCodeRespod==${response.statusCode}");

      if (statusCode == 200 || statusCode == 201) {
        //{"code":200,"message":"User deleted","success":true}
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      log("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> eventCategoryEntered(String eventName, String mytoken) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/event-category"),
          body: jsonEncode({"name": eventName}), headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["categoryId"] = jsonResponse["data"]["id"];
        result["categoryName"] = jsonResponse["data"]["name"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> sendGift(String amount, String mytoken, String receiverTag, String transactionPin) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/gifting/send-gift"),
          body: jsonEncode({"amount": amount, "receiverTag": receiverTag, "transactionPin": transactionPin}),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result["dateCreated"] = jsonResponse['data']["dateCreated"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> userByTag(String userTag, String mytoken) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.get(Uri.parse("$url/user/find-by-tag/$userTag"),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        // result["message"] =jsonResponse["message"];
        result["firstName"] = jsonResponse['data']['firstName'];
        result["lastName"] = jsonResponse['data']['lastName'];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> editEvent(String mytoken, String eventName, String eventDescription, String venue, String eventDate, String time, String category, String eventCoverImage,
      String eventId, String longitude, String latitude) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.patch(Uri.parse("$url/event"),
          body: jsonEncode({
            "eventName": eventName,
            "eventDescription": eventDescription,
            "venue": venue,
            "eventDate": eventDate,
            "time": time,
            "eventCategoryId": category,
            "eventCoverImage": eventCoverImage,
            "eventId": eventId,
            "eventStatus": "UPCOMING",
            "eventGeoCoordinates": {"longitude": longitude, "latitude": latitude},
            "status": true
          }),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        //        result["category"] =jsonResponse["data"]["eventCategory"]["name"];
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("errrr=${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<ApiResponse<EventsModel>> eventsList(String mytoken, String userId) {
    return http.get(Uri.parse("$url/event?userId=$userId"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = EventsModel.fromJson(jsonDecode(response.body));
        return ApiResponse<EventsModel>(data: note1);
      } else {
        return ApiResponse<EventsModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      if (e.toString().contains("SocketException")) {
        return ApiResponse<EventsModel>(error: true, errorMessage: 'Error in network connection');
      } else {
        return ApiResponse<EventsModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');
      }
    });
  }

  Future<ApiResponse<OngoingEventModel>> ongoingEventsList(String mytoken) {
    return http.get(Uri.parse("$url/event/ongoing/events-for-current-user"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = OngoingEventModel.fromJson(jsonDecode(response.body));
        return ApiResponse<OngoingEventModel>(data: note1);
      } else {
        return ApiResponse<OngoingEventModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      if (e.toString().contains("SocketException")) {
        return ApiResponse<OngoingEventModel>(error: true, errorMessage: 'Error in network connection');
      } else {
        return ApiResponse<OngoingEventModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');
      }
    });
  }

  Future<ApiResponse<NewDataPlanModel>> findPlanByProvider(String mytoken, String provider) {
    return http.get(Uri.parse("$url/bill/data-purchase/find-plans/$provider"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        final note1 = NewDataPlanModel.fromJson(jsonDecode(response.body));
        return ApiResponse<NewDataPlanModel>(data: note1);
      } else {
        return ApiResponse<NewDataPlanModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
    }).catchError((e) {
      if (e.toString().contains("SocketException")) {
        return ApiResponse<NewDataPlanModel>(error: true, errorMessage: 'Error in network connection');
      } else {
        return ApiResponse<NewDataPlanModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');
      }
    });
  }

  Future<ApiResponse<DataPlanModel>> findCablePlanByProvider(String mytoken, String provider) {
    return http.get(Uri.parse("$url/bill/merchants/find-plans/$provider"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        final note1 = DataPlanModel.fromJson(jsonDecode(response.body));
        return ApiResponse<DataPlanModel>(data: note1);
      } else {
        return ApiResponse<DataPlanModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
    }).catchError((e) {
      if (e.toString().contains("SocketException")) {
        return ApiResponse<DataPlanModel>(error: true, errorMessage: 'Error in network connection');
      } else {
        return ApiResponse<DataPlanModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');
      }
    });
  }

  Future<ApiResponse<OngoingEventModel>> pastEventsList(String mytoken) {
    return http.get(Uri.parse("$url/event/past/events-for-current-user"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = OngoingEventModel.fromJson(jsonDecode(response.body));
        return ApiResponse<OngoingEventModel>(data: note1);
      } else {
        return ApiResponse<OngoingEventModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      if (e.toString().contains("SocketException")) {
        return ApiResponse<OngoingEventModel>(error: true, errorMessage: 'Error in network connection');
      } else {
        return ApiResponse<OngoingEventModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');
      }
    });
  }

  Future<ApiResponse<CurrentUserModel>> currentUser(String mytoken) {
    return http.get(Uri.parse("$url/event/events-for-current-user"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = CurrentUserModel.fromJson(jsonDecode(response.body));
        return ApiResponse<CurrentUserModel>(data: note1);
      } else {
        return ApiResponse<CurrentUserModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      if (e.toString().contains("SocketException")) {
        return ApiResponse<CurrentUserModel>(error: true, errorMessage: 'Error in network connection');
      } else {
        return ApiResponse<CurrentUserModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');
      }
    });
  }

  Future<Map<String, dynamic>> acceptOrRejectEvent(String eventId, String mytoken, String status) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/event-rsvp"),
          body: jsonEncode({"eventId": eventId, "status": status}),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> sprayEvent(String eventId, String mytoken, String amount, String transactionPin) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/event-spraay"),
          body: jsonEncode({"amount": amount, "eventId": eventId, "transactionPin": transactionPin}),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result["amount"] = jsonResponse["data"]["amount"];
        result["dateCreated"] = jsonResponse["data"]["dateCreated"];
        result["eventCode"] = jsonResponse["eventCode"];
        result["transactionReference"] = jsonResponse["transactionReference"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> transactionPinApi(String mytoken, String transactionPin) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.get(Uri.parse("$url/user/verify/transaction-pin/$transactionPin"),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> userSaveBankApi(String mytoken, String bankCode, String accountNumber) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/user-account"),
          body: jsonEncode({"bankCode": bankCode, "accountNumber": accountNumber}),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["accountName"] = jsonResponse["data"]["accountName"];
        result["accountNumber"] = jsonResponse["data"]["accountNumber"];
        result["bankCode"] = jsonResponse["data"]["bankCode"];
        result["bankName"] = jsonResponse["data"]["bankName"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> withdrawalApi(String mytoken, String bankName, String accountNumber, String bankCode, String transactionPin, String amount) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/withdrawal"),
          body: jsonEncode({"bankName": bankName, "bankCode": bankCode, "accountNumber": accountNumber, "transactionPin": transactionPin, "amount": amount}),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);

        result["message"] = jsonResponse["message"];
        result["transactionId"] = jsonResponse["data"]["transactionId"];
        result["amount"] = jsonResponse["data"]["amount"];
        result["type"] = "Withdrawal";
        result["dateCreated"] = jsonResponse["data"]["dateCreated"];
        result["reference"] = jsonResponse["data"]["reference"];

        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> checkbalanceBeforeWithdrawingApi(String mytoken, String amount) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.get(Uri.parse("$url/user/account/check-balance-before-debit/$amount"),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> totalPeopleInvitedApi(String mytoken, String eventID) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.get(Uri.parse("$url/event/event-summary/$eventID"),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);

        result["totalPeopleInvited"] = jsonResponse["data"]["totalPeopleInvited"];
        result["totalRsvp"] = jsonResponse["data"]["totalRsvp"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> totalAmtSprayedApi(String mytoken, String eventID) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.get(Uri.parse("$url/event-spraay/total-amount-sprayed-at-event/$eventID"),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);

        result["total"] = jsonResponse["total"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> airtimePurchaseApi(String mytoken, String providerId, String phoneNumber, String amount, String transactionPin) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/bill/airtime-purchase"),
          body: jsonEncode({"providerId": providerId, "phoneNumber": phoneNumber, "amount": amount, "transactionPin": transactionPin}),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);

        result["message"] = jsonResponse["message"];
        result["phoneNumber"] = jsonResponse["data"]["phoneNumber"];
        // result["provider"] =jsonResponse["data"]["provider"];
        result["dateCreated"] = jsonResponse["data"]["dateCreated"];
        result["transactionId"] = jsonResponse["data"]["transactionId"];

        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);

        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> electricityUnitPurchaseApi(String mytoken, String provider, String meterNumber, String amount, String transactionPin, String plan, String billerName) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/bill/electricity-unit-purchase"),
          body: jsonEncode({"providerId": provider, "meterNumber": meterNumber, "amount": amount, "transactionPin": transactionPin, "merchantPlan": plan /*,"billerName":billerName*/}),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);

        result["message"] = jsonResponse["message"];
        result["phoneNumber"] = jsonResponse["data"]["meterNumber"];
        // result["provider"] =jsonResponse["data"]["provider"];
        result["dateCreated"] = jsonResponse["data"]["dateCreated"];
        result["transactionId"] = jsonResponse["data"]["transactionId"];

        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> betGamePurchaseApi(String mytoken, String provider, String bettingWalletId, String amount, String transactionPin, String plan, String billerName) async {
    Map<String, dynamic> result = {};
    try {
      Map dataPayload = {
        "providerId": provider,
        "bettingWalletId": bettingWalletId,
        "amount": amount,
        "transactionPin": transactionPin,
      };

      if (plan.isNotEmpty || plan != "") {
        dataPayload["merchantPlan"] = plan;
      }

      var response = await http.post(Uri.parse("$url/bill/fund-betting-wallet"),
          body: jsonEncode(dataPayload), headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);

        result["message"] = jsonResponse["message"];
        result["phoneNumber"] = jsonResponse["data"]["bettingWalletId"];
        // result["provider"] =jsonResponse["data"]["provider"];
        result["dateCreated"] = jsonResponse["data"]["dateCreated"];
        result["transactionId"] = jsonResponse["data"]["transactionId"];

        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> dataPurchaseApi(String mytoken, String provider, String phoneNumber, String dataPlanId, String transactionPin, String dataSubCode) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/bill/data-purchase"),
          body: jsonEncode({"providerId": dataSubCode, "phoneNumber": phoneNumber, "dataPlanId": int.parse(dataPlanId), "transactionPin": transactionPin}),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result["phoneNumber"] = jsonResponse["data"]["phoneNumber"];
        // result["provider"] =jsonResponse["data"]["provider"];
        result["dateCreated"] = jsonResponse["data"]["dateCreated"];
        result["transactionId"] = jsonResponse["data"]["transactionId"];

        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> cablePurchaseApi(String mytoken, String provider, String phoneNumber, String dataPlanId, String transactionPin, String amount, String cableCode) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.post(Uri.parse("$url/bill/cable-purchase"),
          body: jsonEncode({"providerId": cableCode, "smartCardNumber": phoneNumber, "cablePlanId": dataPlanId, "transactionPin": transactionPin, "amount": amount}),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result["phoneNumber"] = jsonResponse["data"]["smartCardNumber"];
        // result["provider"] =jsonResponse["data"]["providerId"];
        result["dateCreated"] = jsonResponse["data"]["dateCreated"];
        result["transactionId"] = jsonResponse["data"]["transactionId"];

        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      print("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> verifyElectricityUnitPurchaseApi(String mytoken, String provider, String meterNumber, String amount, String plan) async {
    Map<String, dynamic> result = {};

    try {
      Map dataPayload = {"providerId": provider, "meterNumber": meterNumber, "amount": amount};

      if (plan.isNotEmpty || plan != "") {
        dataPayload["merchantPlan"] = plan;
      }

      var response = await http.post(Uri.parse("$url/bill/electricity-unit-purchase/verify"),
          body: jsonEncode(dataPayload), headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result["billerName"] = jsonResponse["data"]["billerName"];
        result["name"] = jsonResponse["data"]["name"];
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } on HttpException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on SocketException {
      result["message"] = "Error in network connection";
      result['error'] = true;
    } on FormatException {
      result["message"] = "invalid format";
      result['error'] = true;
    } catch (e) {
      // print("object${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<ApiResponse<JoinEventModel>> joinEvent(String mytoken, String eventCode) {
    return http.get(Uri.parse("$url/event/by-code/$eventCode"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = JoinEventModel.fromJson(jsonDecode(response.body));
        return ApiResponse<JoinEventModel>(data: note1);
      } else {
        return ApiResponse<JoinEventModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      if (e.toString().contains("SocketException")) {
        return ApiResponse<JoinEventModel>(error: true, errorMessage: 'Error in network connection');
      } else {
        return ApiResponse<JoinEventModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');
      }
    });
  }

  Future<ApiResponse<TransactionModels>> transactionListApi(String mytoken, String userId) {
    return http.get(Uri.parse("$url/transaction?userId=$userId"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        final note1 = TransactionModels.fromJson(jsonDecode(response.body));
        return ApiResponse<TransactionModels>(data: note1);
      } else {
        return ApiResponse<TransactionModels>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
      // else if(response.statusCode==400){return ApiResponse<UserResponse>( error: true, errorMessage: 'Something went wrong');}
    }).catchError((e) {
      if (e.toString().contains("SocketException")) {
        return ApiResponse<TransactionModels>(error: true, errorMessage: 'Error in network connection');
      } else {
        return ApiResponse<TransactionModels>(error: true, errorMessage: 'Something went wrong ${e.toString()}');
      }
    });
  }

  Future<ApiResponse<ListOfBankModel>> listOfBankApi(String mytoken) {
    return http.get(Uri.parse("$url/wallet/list-of-banks"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        final note1 = ListOfBankModel.fromJson(jsonDecode(response.body));
        return ApiResponse<ListOfBankModel>(data: note1);
      } else {
        return ApiResponse<ListOfBankModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
    }).catchError((e) {
      if (e.toString().contains("SocketException")) {
        return ApiResponse<ListOfBankModel>(error: true, errorMessage: 'Error in network connection');
      } else {
        return ApiResponse<ListOfBankModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');
      }
    });
  }

  Future<ApiResponse<NotificationModel>> notificationApi(String mytoken, String uid) {
    return http.get(Uri.parse("$url/notification?userId=$uid"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = NotificationModel.fromJson(jsonDecode(response.body));
        return ApiResponse<NotificationModel>(data: note1);
      } else {
        return ApiResponse<NotificationModel>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
    }).catchError((e) {
      if (e.toString().contains("SocketException")) {
        return ApiResponse<NotificationModel>(error: true, errorMessage: 'Error in network connection');
      } else {
        return ApiResponse<NotificationModel>(error: true, errorMessage: 'Something went wrong ${e.toString()}');
      }
    });
  }

  Future<ApiResponse<UserSavedBankModels>> savedBanksInfoApi(String mytoken) {
    return http.get(Uri.parse("$url/user-account"), headers: {'accept': 'application/json', 'Authorization': 'Bearer $mytoken'}).then((response) {
      if (response.statusCode == 200) {
        // final body=json.decode(response.body);
        final note1 = UserSavedBankModels.fromJson(jsonDecode(response.body));
        return ApiResponse<UserSavedBankModels>(data: note1);
      } else {
        return ApiResponse<UserSavedBankModels>(error: true, errorMessage: jsonDecode(response.body)['message']);
      }
    }).catchError((e) {
      if (e.toString().contains("SocketException")) {
        return ApiResponse<UserSavedBankModels>(error: true, errorMessage: 'Error in network connection');
      } else {
        return ApiResponse<UserSavedBankModels>(error: true, errorMessage: 'Something went wrong ${e.toString()}');
      }
    });
  }

  Future<Map<String, dynamic>> downloadSingleTransaction(String mytoken, String transactionListID) async {
    Map<String, dynamic> result = {};
    try {
      var response = await http.get(Uri.parse("https://spraay-api-577f3dc0a0fe.herokuapp.com/transaction/download-receipt/$transactionListID"),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        result["bytes"] = response.bodyBytes;
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } catch (e) {
      print("objecteeeroo${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }

  Future<Map<String, dynamic>> downloadSOA(String mytoken, String userId, String startDate, String endDate) async {
    Map<String, dynamic> result = {};

    try {
      var response = await http.get(Uri.parse("$url/transaction/export-soa?startDate=$startDate&endDate=$endDate"),
          headers: {"Accept": "application/json", 'Authorization': 'Bearer $mytoken', 'Content-Type': 'application/json'}).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        result["bytes"] = response.bodyBytes;
        result['error'] = false;
      } else {
        var jsonResponse = convert.jsonDecode(response.body);
        result["message"] = jsonResponse["message"];
        result['error'] = true;
      }
    } catch (e) {
      print("objecteeeroo${e.toString()}");
      result["message"] = "Something went wrong";
      result['error'] = true;
    }
    return result;
  }
}
