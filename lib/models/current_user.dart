// To parse this JSON data, do
//
//     final currentUserModel = currentUserModelFromJson(jsonString);

import 'dart:convert';

CurrentUserModel currentUserModelFromJson(String str) => CurrentUserModel.fromJson(json.decode(str));

String currentUserModelToJson(CurrentUserModel data) => json.encode(data.toJson());

class CurrentUserModel {
  bool? success;
  String? message;
  int? code;
  List<DatumCurrentUser>? data;

  CurrentUserModel({
    this.success,
    this.message,
    this.code,
    this.data,
  });

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) => CurrentUserModel(
    success: json["success"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? [] : List<DatumCurrentUser>.from(json["data"]!.map((x) => DatumCurrentUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "code": code,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DatumCurrentUser {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? eventName;
  String? eventDescription;
  String? qrCodeForEvent;
  String? eventCode;
  DateTime? eventDate;
  String? time;
  String? venue;
  String? eventTag;
  String? eventCategoryId;
  String? eventStatus;
  String? eventCoverImage;
  String? userId;
  bool? isNotificationSent;
  bool? isRsvpNotificationSent;
  EventGeoCoordinates? eventGeoCoordinates;
  User? user;
  EventCategory? eventCategory;
  List<dynamic>? eventInvites;

  DatumCurrentUser({
    this.id,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.eventName,
    this.eventDescription,
    this.qrCodeForEvent,
    this.eventCode,
    this.eventDate,
    this.time,
    this.venue,
    this.eventTag,
    this.eventCategoryId,
    this.eventStatus,
    this.eventCoverImage,
    this.userId,
    this.isNotificationSent,
    this.isRsvpNotificationSent,
    this.eventGeoCoordinates,
    this.user,
    this.eventCategory,
    this.eventInvites,
  });

  factory DatumCurrentUser.fromJson(Map<String, dynamic> json) => DatumCurrentUser(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    eventName: json["eventName"],
    eventDescription: json["eventDescription"],
    qrCodeForEvent: json["qrCodeForEvent"],
    eventCode: json["eventCode"],
    eventDate: json["eventDate"] == null ? null : DateTime.parse(json["eventDate"]),
    time: json["time"],
    venue: json["venue"],
    eventTag: json["eventTag"],
    eventCategoryId: json["eventCategoryId"],
    eventStatus: json["eventStatus"],
    eventCoverImage: json["eventCoverImage"],
    userId: json["userId"],
    isNotificationSent: json["isNotificationSent"],
    isRsvpNotificationSent: json["isRSVPNotificationSent"],
    eventGeoCoordinates: json["eventGeoCoordinates"] == null ? null : EventGeoCoordinates.fromJson(json["eventGeoCoordinates"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    eventCategory: json["eventCategory"] == null ? null : EventCategory.fromJson(json["eventCategory"]),
    eventInvites: json["eventInvites"] == null ? [] : List<dynamic>.from(json["eventInvites"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "dateCreated": dateCreated?.toIso8601String(),
    "dateUpdated": dateUpdated?.toIso8601String(),
    "eventName": eventName,
    "eventDescription": eventDescription,
    "qrCodeForEvent": qrCodeForEvent,
    "eventCode": eventCode,
    "eventDate": "${eventDate!.year.toString().padLeft(4, '0')}-${eventDate!.month.toString().padLeft(2, '0')}-${eventDate!.day.toString().padLeft(2, '0')}",
    "time": time,
    "venue": venue,
    "eventTag": eventTag,
    "eventCategoryId": eventCategoryId,
    "eventStatus": eventStatus,
    "eventCoverImage": eventCoverImage,
    "userId": userId,
    "isNotificationSent": isNotificationSent,
    "isRSVPNotificationSent": isRsvpNotificationSent,
    "eventGeoCoordinates": eventGeoCoordinates?.toJson(),
    "user": user?.toJson(),
    "eventCategory": eventCategory?.toJson(),
    "eventInvites": eventInvites == null ? [] : List<dynamic>.from(eventInvites!.map((x) => x)),
  };
}

class EventCategory {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? name;
  dynamic userId;

  EventCategory({
    this.id,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.name,
    this.userId,
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) => EventCategory(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    name: json["name"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "dateCreated": dateCreated?.toIso8601String(),
    "dateUpdated": dateUpdated?.toIso8601String(),
    "name": name,
    "userId": userId,
  };
}

class EventGeoCoordinates {
  String? longitude;
  String? latitude;

  EventGeoCoordinates({
    this.longitude,
    this.latitude,
  });

  factory EventGeoCoordinates.fromJson(Map<String, dynamic> json) => EventGeoCoordinates(
    longitude: json["longitude"],
    latitude: json["latitude"],
  );

  Map<String, dynamic> toJson() => {
    "longitude": longitude,
    "latitude": latitude,
  };
}

class User {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? email;
  String? phoneNumber;
  String? formattedPhoneNumber;
  String? firstName;
  String? lastName;
  double? walletBalance;
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
  DateTime? dob;
  String? userTag;
  String? transactionPin;
  dynamic externalUserId;
  bool? allowPushNotifications;
  bool? allowSmsNotifications;
  bool? allowEmailNotifications;
  bool? displayWalletBalance;
  bool? enableFaceId;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    formattedPhoneNumber: json["formattedPhoneNumber"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    walletBalance: json["walletBalance"]?.toDouble(),
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
