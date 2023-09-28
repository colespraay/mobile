// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  bool? success;
  int? code;
  DataResponse? data;
  String? message;

  UserResponse({
    this.success,
    this.code,
    this.data,
    this.message,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    success: json["success"],
    code: json["code"],
    data: json["data"] == null ? null : DataResponse.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "data": data?.toJson(),
    "message": message,
  };
}

class DataResponse {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  dynamic email;
  String? phoneNumber;
  dynamic firstName;
  dynamic lastName;
  dynamic walletBalance;
  dynamic uniqueVerificationCode;
  bool? isNewUser;
  String? role;
  String? deviceId;
  String? authProvider;
  String? profileImageUrl;
  dynamic bvn;
  dynamic virtualAccountName;
  dynamic virtualAccountNumber;
  dynamic bankName;
  dynamic gender;
  dynamic dob;
  String? userTag;
  String? transactionPin;
  dynamic externalUserId;
  bool? allowPushNotifications;
  bool? allowSmsNotifications;
  bool? allowEmailNotifications;
  bool? displayWalletBalance;
  bool? enableFaceId;

  DataResponse({
    this.id,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.walletBalance,
    this.uniqueVerificationCode,
    this.isNewUser,
    this.role,
    this.deviceId,
    this.authProvider,
    this.profileImageUrl,
    this.bvn,
    this.virtualAccountName,
    this.virtualAccountNumber,
    this.bankName,
    this.gender,
    this.dob,
    this.userTag,
    this.transactionPin,
    this.externalUserId,
    this.allowPushNotifications,
    this.allowSmsNotifications,
    this.allowEmailNotifications,
    this.displayWalletBalance,
    this.enableFaceId,
  });

  factory DataResponse.fromJson(Map<String, dynamic> json) => DataResponse(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    walletBalance: json["walletBalance"],
    uniqueVerificationCode: json["uniqueVerificationCode"],
    isNewUser: json["isNewUser"],
    role: json["role"],
    deviceId: json["deviceId"],
    authProvider: json["authProvider"],
    profileImageUrl: json["profileImageUrl"],
    bvn: json["bvn"],
    virtualAccountName: json["virtualAccountName"],
    virtualAccountNumber: json["virtualAccountNumber"],
    bankName: json["bankName"],
    gender: json["gender"],
    dob: json["dob"],
    userTag: json["userTag"],
    transactionPin: json["transactionPin"],
    externalUserId: json["externalUserId"],
    allowPushNotifications: json["allowPushNotifications"],
    allowSmsNotifications: json["allowSmsNotifications"],
    allowEmailNotifications: json["allowEmailNotifications"],
    displayWalletBalance: json["displayWalletBalance"],
    enableFaceId: json["enableFaceId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "dateCreated": dateCreated?.toIso8601String(),
    "dateUpdated": dateUpdated?.toIso8601String(),
    "email": email,
    "phoneNumber": phoneNumber,
    "firstName": firstName,
    "lastName": lastName,
    "walletBalance":walletBalance,
    "uniqueVerificationCode": uniqueVerificationCode,
    "isNewUser": isNewUser,
    "role": role,
    "deviceId": deviceId,
    "authProvider": authProvider,
    "profileImageUrl": profileImageUrl,
    "bvn": bvn,
    "virtualAccountName": virtualAccountName,
    "virtualAccountNumber": virtualAccountNumber,
    "bankName": bankName,
    "gender": gender,
    "dob": dob,
    "userTag": userTag,
    "transactionPin": transactionPin,
    "externalUserId": externalUserId,
    "allowPushNotifications": allowPushNotifications,
    "allowSmsNotifications": allowSmsNotifications,
    "allowEmailNotifications": allowEmailNotifications,
    "displayWalletBalance": displayWalletBalance,
    "enableFaceId": enableFaceId,
  };
}
