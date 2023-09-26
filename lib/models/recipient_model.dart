// To parse this JSON data, do
//
//     final recipientModel = recipientModelFromJson(jsonString);

import 'dart:convert';

RecipientModel recipientModelFromJson(String str) => RecipientModel.fromJson(json.decode(str));

String recipientModelToJson(RecipientModel data) => json.encode(data.toJson());

class RecipientModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  RecipientModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory RecipientModel.fromJson(Map<String, dynamic> json) => RecipientModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  List<B>? b;
  List<B>? d;
  List<B>? g;
  List<B>? n;

  Data({
    this.b,
    this.d,
    this.g,
    this.n,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    b: json["B"] == null ? [] : List<B>.from(json["B"]!.map((x) => B.fromJson(x))),
    d: json["D"] == null ? [] : List<B>.from(json["D"]!.map((x) => B.fromJson(x))),
    g: json["G"] == null ? [] : List<B>.from(json["G"]!.map((x) => B.fromJson(x))),
    n: json["N"] == null ? [] : List<B>.from(json["N"]!.map((x) => B.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "B": b == null ? [] : List<dynamic>.from(b!.map((x) => x.toJson())),
    "D": d == null ? [] : List<dynamic>.from(d!.map((x) => x.toJson())),
    "G": g == null ? [] : List<dynamic>.from(g!.map((x) => x.toJson())),
    "N": n == null ? [] : List<dynamic>.from(n!.map((x) => x.toJson())),
  };
}

class B {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? email;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  int? walletBalance;
  String? uniqueVerificationCode;
  bool? isNewUser;
  String? role;
  String? deviceId;
  String? authProvider;
  String? profileImageUrl;
  dynamic bvn;
  dynamic bankCustomerId;
  dynamic virtualAccountName;
  dynamic virtualAccountNumber;
  dynamic bankName;
  String? gender;
  DateTime? dob;
  String? userTag;
  String? transactionPin;
  dynamic externalUserId;
  bool? allowPushNotifications;
  bool? allowSmsNotifications;
  bool? allowEmailNotifications;
  bool? displayWalletBalance;
  bool? enableFaceId;
  String? firstLetter;

  B({
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
    this.bankCustomerId,
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
    this.firstLetter,
  });

  factory B.fromJson(Map<String, dynamic> json) => B(
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
    role:json["role"],
    deviceId: json["deviceId"],
    authProvider: json["authProvider"],
    profileImageUrl: json["profileImageUrl"],
    bvn: json["bvn"],
    bankCustomerId: json["bankCustomerId"],
    virtualAccountName: json["virtualAccountName"],
    virtualAccountNumber: json["virtualAccountNumber"],
    bankName: json["bankName"],
    gender: json["gender"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    userTag: json["userTag"],
    transactionPin: json["transactionPin"],
    externalUserId: json["externalUserId"],
    allowPushNotifications: json["allowPushNotifications"],
    allowSmsNotifications: json["allowSmsNotifications"],
    allowEmailNotifications: json["allowEmailNotifications"],
    displayWalletBalance: json["displayWalletBalance"],
    enableFaceId: json["enableFaceId"],
    firstLetter: json["firstLetter"],
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
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "userTag": userTag,
    "transactionPin": transactionPin,
    "externalUserId": externalUserId,
    "allowPushNotifications": allowPushNotifications,
    "allowSmsNotifications": allowSmsNotifications,
    "allowEmailNotifications": allowEmailNotifications,
    "displayWalletBalance": displayWalletBalance,
    "enableFaceId": enableFaceId,
    "firstLetter": firstLetter,
  };
}

