// To parse this JSON data, do
//
//     final eventsModel = eventsModelFromJson(jsonString);

import 'dart:convert';

EventsModel eventsModelFromJson(String str) => EventsModel.fromJson(json.decode(str));

String eventsModelToJson(EventsModel data) => json.encode(data.toJson());

class EventsModel {
  bool? success;
  String? message;
  int? code;
  List<Datum>? data;

  EventsModel({
    this.success,
    this.message,
    this.code,
    this.data,
  });

  factory EventsModel.fromJson(Map<String, dynamic> json) => EventsModel(
    success: json["success"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "code": code,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
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
  String? category;
  String? eventCoverImage;
  String? userId;
  User? user;
  List<EventInvite>? eventInvites;

  Datum({
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
    this.category,
    this.eventCoverImage,
    this.userId,
    this.user,
    this.eventInvites,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    category: json["category"],
    eventCoverImage: json["eventCoverImage"],
    userId: json["userId"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    eventInvites: json["eventInvites"] == null ? [] : List<EventInvite>.from(json["eventInvites"]!.map((x) => EventInvite.fromJson(x))),
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
    "category": category,
    "eventCoverImage": eventCoverImage,
    "userId": userId,
    "user": user?.toJson(),
    "eventInvites": eventInvites == null ? [] : List<dynamic>.from(eventInvites!.map((x) => x.toJson())),
  };
}

class EventInvite {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? userId;
  String? eventId;
  bool? isInviteSent;
  User? user;

  EventInvite({
    this.id,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.userId,
    this.eventId,
    this.isInviteSent,
    this.user,
  });

  factory EventInvite.fromJson(Map<String, dynamic> json) => EventInvite(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    userId: json["userId"],
    eventId: json["eventId"],
    isInviteSent: json["isInviteSent"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "dateCreated": dateCreated?.toIso8601String(),
    "dateUpdated": dateUpdated?.toIso8601String(),
    "userId": userId,
    "eventId": eventId,
    "isInviteSent": isInviteSent,
    "user": user?.toJson(),
  };
}

class User {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? email;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? uniqueVerificationCode;
  bool? isNewUser;
  Role? role;
  String? deviceId;
  AuthProvider? authProvider;
  String? profileImageUrl;
  dynamic bvn;
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

  User({
    this.id,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
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

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    uniqueVerificationCode: json["uniqueVerificationCode"],
    isNewUser: json["isNewUser"],
    role: roleValues.map[json["role"]]!,
    deviceId: json["deviceId"],
    authProvider: authProviderValues.map[json["authProvider"]]!,
    profileImageUrl: json["profileImageUrl"],
    bvn: json["bvn"],
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
    "firstName": firstName,
    "lastName": lastName,
    "uniqueVerificationCode": uniqueVerificationCode,
    "isNewUser": isNewUser,
    "role": roleValues.reverse[role],
    "deviceId": deviceId,
    "authProvider": authProviderValues.reverse[authProvider],
    "profileImageUrl": profileImageUrl,
    "bvn": bvn,
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

enum AuthProvider {
  LOCAL
}

final authProviderValues = EnumValues({
  "LOCAL": AuthProvider.LOCAL
});

enum Role {
  CUSTOMER
}

final roleValues = EnumValues({
  "CUSTOMER": Role.CUSTOMER
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
