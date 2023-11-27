// To parse this JSON data, do
//
//     final userPhoneWithNameContactModel = userPhoneWithNameContactModelFromJson(jsonString);

import 'dart:convert';

UserPhoneWithNameContactModel userPhoneWithNameContactModelFromJson(String str) => UserPhoneWithNameContactModel.fromJson(json.decode(str));

String userPhoneWithNameContactModelToJson(UserPhoneWithNameContactModel data) => json.encode(data.toJson());

class UserPhoneWithNameContactModel {
  bool? success;
  String? message;
  int? code;
  List<UserPhoneWithNameContactDatum>? data;

  UserPhoneWithNameContactModel({
    this.success,
    this.message,
    this.code,
    this.data,
  });

  factory UserPhoneWithNameContactModel.fromJson(Map<String, dynamic> json) => UserPhoneWithNameContactModel(
    success: json["success"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? [] : List<UserPhoneWithNameContactDatum>.from(json["data"]!.map((x) => UserPhoneWithNameContactDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "code": code,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class UserPhoneWithNameContactDatum {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? email;
  String? phoneNumber;
  String? formattedPhoneNumber;
  String? firstName;
  String? lastName;
  String? walletBalance;
  String? uniqueVerificationCode;
  bool? isNewUser;
  String? role;
  String? deviceId;
  String? authProvider;
  String? profileImageUrl;
  String? bvn;
  dynamic bankCustomerId;
  String? virtualAccountName;
  String? virtualAccountNumber;
  String? bankName;
  String? gender;
  String? flutterwaveUserKey;
  String? flutterwaveNarration;
  DateTime? dob;
  String? userTag;
  String? transactionPin;
  dynamic externalUserId;
  bool? allowPushNotifications;
  bool? allowSmsNotifications;
  bool? allowEmailNotifications;
  bool? displayWalletBalance;
  bool? enableFaceId;

  UserPhoneWithNameContactDatum({
    this.id,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.email,
    this.phoneNumber,
    this.formattedPhoneNumber,
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
    this.bankCustomerId,
    this.virtualAccountName,
    this.virtualAccountNumber,
    this.bankName,
    this.gender,
    this.flutterwaveUserKey,
    this.flutterwaveNarration,
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

  factory UserPhoneWithNameContactDatum.fromJson(Map<String, dynamic> json) => UserPhoneWithNameContactDatum(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    formattedPhoneNumber: json["formattedPhoneNumber"],
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
    bankCustomerId: json["bankCustomerId"],
    virtualAccountName: json["virtualAccountName"],
    virtualAccountNumber: json["virtualAccountNumber"],
    bankName: json["bankName"],
    gender: json["gender"],
    flutterwaveUserKey: json["flutterwaveUserKey"],
    flutterwaveNarration: json["flutterwaveNarration"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
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
    "formattedPhoneNumber": formattedPhoneNumber,
    "firstName": firstName,
    "lastName": lastName,
    "walletBalance": walletBalance,
    "uniqueVerificationCode": uniqueVerificationCode,
    "isNewUser": isNewUser,
    "role": role,
    "deviceId": deviceId,
    "authProvider": authProvider,
    "profileImageUrl": profileImageUrl,
    "bvn": bvn,
    "bankCustomerId": bankCustomerId,
    "virtualAccountName": virtualAccountName,
    "virtualAccountNumber": virtualAccountNumber,
    "bankName": bankName,
    "gender": gender,
    "flutterwaveUserKey": flutterwaveUserKey,
    "flutterwaveNarration": flutterwaveNarration,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
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
