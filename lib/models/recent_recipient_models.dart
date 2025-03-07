// To parse this JSON data, do
//
//     final recentRecipientModel = recentRecipientModelFromJson(jsonString);

import 'dart:convert';

RecentRecipientModel recentRecipientModelFromJson(String str) => RecentRecipientModel.fromJson(json.decode(str));

String recentRecipientModelToJson(RecentRecipientModel data) => json.encode(data.toJson());

class RecentRecipientModel {
  bool? success;
  int? code;
  String? message;
  List<DatumRecent>? data;
  PaginationControl? paginationControl;

  RecentRecipientModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.paginationControl,
  });

  factory RecentRecipientModel.fromJson(Map<String, dynamic> json) => RecentRecipientModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<DatumRecent>.from(json["data"]!.map((x) => DatumRecent.fromJson(x))),
    paginationControl: json["paginationControl"] == null ? null : PaginationControl.fromJson(json["paginationControl"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "paginationControl": paginationControl?.toJson(),
  };
}

class DatumRecent {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? email;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? password;
  int? walletBalance;
  String? uniqueVerificationCode;
  bool? isNewUser;
  String? role;
  String? deviceId;
  String? authProvider;
  String? profileImageUrl;
  String? bvn;
  String? bankCustomerId;
  String? virtualAccountName;
  String? virtualAccountNumber;
  String? bankName;
  String? gender;
  DateTime? dob;
  String? userTag;
  String? transactionPin;
  String? externalUserId;
  bool? allowPushNotifications;
  bool? allowSmsNotifications;
  bool? allowEmailNotifications;
  bool? displayWalletBalance;
  bool? enableFaceId;
  List<EventElement>? events;
  List<Event>? eventSpraays;
  List<Event>? eventInvites;
  List<Event>? eventRsvps;
  List<Notification>? notifications;
  List<Transaction>? transactions;
  List<Transaction>? receivedTransactions;
  List<Gift>? gifts;

  DatumRecent({
    this.id,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.password,
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
    this.events,
    this.eventSpraays,
    this.eventInvites,
    this.eventRsvps,
    this.notifications,
    this.transactions,
    this.receivedTransactions,
    this.gifts,
  });

  factory DatumRecent.fromJson(Map<String, dynamic> json) => DatumRecent(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    password: json["password"],
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
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    userTag: json["userTag"],
    transactionPin: json["transactionPin"],
    externalUserId: json["externalUserId"],
    allowPushNotifications: json["allowPushNotifications"],
    allowSmsNotifications: json["allowSmsNotifications"],
    allowEmailNotifications: json["allowEmailNotifications"],
    displayWalletBalance: json["displayWalletBalance"],
    enableFaceId: json["enableFaceId"],
    events: json["events"] == null ? [] : List<EventElement>.from(json["events"]!.map((x) => EventElement.fromJson(x))),
    eventSpraays: json["eventSpraays"] == null ? [] : List<Event>.from(json["eventSpraays"]!.map((x) => Event.fromJson(x))),
    eventInvites: json["eventInvites"] == null ? [] : List<Event>.from(json["eventInvites"]!.map((x) => Event.fromJson(x))),
    eventRsvps: json["eventRsvps"] == null ? [] : List<Event>.from(json["eventRsvps"]!.map((x) => Event.fromJson(x))),
    notifications: json["notifications"] == null ? [] : List<Notification>.from(json["notifications"]!.map((x) => Notification.fromJson(x))),
    transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
    receivedTransactions: json["receivedTransactions"] == null ? [] : List<Transaction>.from(json["receivedTransactions"]!.map((x) => Transaction.fromJson(x))),
    gifts: json["gifts"] == null ? [] : List<Gift>.from(json["gifts"]!.map((x) => Gift.fromJson(x))),
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
    "password": password,
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
    "dob": dob?.toIso8601String(),
    "userTag": userTag,
    "transactionPin": transactionPin,
    "externalUserId": externalUserId,
    "allowPushNotifications": allowPushNotifications,
    "allowSmsNotifications": allowSmsNotifications,
    "allowEmailNotifications": allowEmailNotifications,
    "displayWalletBalance": displayWalletBalance,
    "enableFaceId": enableFaceId,
    "events": events == null ? [] : List<dynamic>.from(events!.map((x) => x.toJson())),
    "eventSpraays": eventSpraays == null ? [] : List<dynamic>.from(eventSpraays!.map((x) => x.toJson())),
    "eventInvites": eventInvites == null ? [] : List<dynamic>.from(eventInvites!.map((x) => x.toJson())),
    "eventRsvps": eventRsvps == null ? [] : List<dynamic>.from(eventRsvps!.map((x) => x.toJson())),
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
    "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    "receivedTransactions": receivedTransactions == null ? [] : List<dynamic>.from(receivedTransactions!.map((x) => x.toJson())),
    "gifts": gifts == null ? [] : List<dynamic>.from(gifts!.map((x) => x.toJson())),
  };
}

class Event {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? user;
  String? event;
  bool? isInviteSent;
  int? amount;
  String? transactionReference;

  Event({
    this.id,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.user,
    this.event,
    this.isInviteSent,
    this.amount,
    this.transactionReference,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    user: json["user"],
    event: json["event"],
    isInviteSent: json["isInviteSent"],
    amount: json["amount"],
    transactionReference: json["transactionReference"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "dateCreated": dateCreated?.toIso8601String(),
    "dateUpdated": dateUpdated?.toIso8601String(),
    "user": user,
    "event": event,
    "isInviteSent": isInviteSent,
    "amount": amount,
    "transactionReference": transactionReference,
  };
}

class EventElement {
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
  String? eventStatus;
  String? eventCoverImage;
  String? user;
  EventGeoCoordinates? eventGeoCoordinates;
  List<Event>? eventSpraays;
  List<Event>? eventInvites;
  List<Event>? eventRsvps;

  EventElement({
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
    this.eventStatus,
    this.eventCoverImage,
    this.user,
    this.eventGeoCoordinates,
    this.eventSpraays,
    this.eventInvites,
    this.eventRsvps,
  });

  factory EventElement.fromJson(Map<String, dynamic> json) => EventElement(
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
    eventStatus: json["eventStatus"],
    eventCoverImage: json["eventCoverImage"],
    user: json["user"],
    eventGeoCoordinates: json["eventGeoCoordinates"] == null ? null : EventGeoCoordinates.fromJson(json["eventGeoCoordinates"]),
    eventSpraays: json["eventSpraays"] == null ? [] : List<Event>.from(json["eventSpraays"]!.map((x) => Event.fromJson(x))),
    eventInvites: json["eventInvites"] == null ? [] : List<Event>.from(json["eventInvites"]!.map((x) => Event.fromJson(x))),
    eventRsvps: json["eventRsvps"] == null ? [] : List<Event>.from(json["eventRsvps"]!.map((x) => Event.fromJson(x))),
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
    "eventDate": eventDate?.toIso8601String(),
    "time": time,
    "venue": venue,
    "category": category,
    "eventStatus": eventStatus,
    "eventCoverImage": eventCoverImage,
    "user": user,
    "eventGeoCoordinates": eventGeoCoordinates?.toJson(),
    "eventSpraays": eventSpraays == null ? [] : List<dynamic>.from(eventSpraays!.map((x) => x.toJson())),
    "eventInvites": eventInvites == null ? [] : List<dynamic>.from(eventInvites!.map((x) => x.toJson())),
    "eventRsvps": eventRsvps == null ? [] : List<dynamic>.from(eventRsvps!.map((x) => x.toJson())),
  };
}

class EventGeoCoordinates {
  int? longitude;
  int? latitude;

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

class Gift {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? receiverUser;
  int? amount;
  String? transaction;

  Gift({
    this.id,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.receiverUser,
    this.amount,
    this.transaction,
  });

  factory Gift.fromJson(Map<String, dynamic> json) => Gift(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    receiverUser: json["receiverUser"],
    amount: json["amount"],
    transaction: json["transaction"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "dateCreated": dateCreated?.toIso8601String(),
    "dateUpdated": dateUpdated?.toIso8601String(),
    "receiverUser": receiverUser,
    "amount": amount,
    "transaction": transaction,
  };
}

class Notification {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? subject;
  String? message;
  String? html;
  String? type;
  String? purpose;
  String? user;
  int? numberOfTries;

  Notification({
    this.id,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.subject,
    this.message,
    this.html,
    this.type,
    this.purpose,
    this.user,
    this.numberOfTries,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    subject: json["subject"],
    message: json["message"],
    html: json["html"],
    type: json["type"],
    purpose: json["purpose"],
    user: json["user"],
    numberOfTries: json["numberOfTries"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "dateCreated": dateCreated?.toIso8601String(),
    "dateUpdated": dateUpdated?.toIso8601String(),
    "subject": subject,
    "message": message,
    "html": html,
    "type": type,
    "purpose": purpose,
    "user": user,
    "numberOfTries": numberOfTries,
  };
}

class Transaction {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  String? user;
  String? receiverUser;
  int? amount;
  int? currentBalanceBeforeTransaction;
  String? narration;
  String? reference;
  String? type;
  String? transactionDate;
  String? createdTime;
  String? createdDate;
  List<Gift>? gifts;

  Transaction({
    this.id,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.user,
    this.receiverUser,
    this.amount,
    this.currentBalanceBeforeTransaction,
    this.narration,
    this.reference,
    this.type,
    this.transactionDate,
    this.createdTime,
    this.createdDate,
    this.gifts,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    user: json["user"],
    receiverUser: json["receiverUser"],
    amount: json["amount"],
    currentBalanceBeforeTransaction: json["currentBalanceBeforeTransaction"],
    narration: json["narration"],
    reference: json["reference"],
    type: json["type"],
    transactionDate: json["transactionDate"],
    createdTime: json["createdTime"],
    createdDate: json["createdDate"],
    gifts: json["gifts"] == null ? [] : List<Gift>.from(json["gifts"]!.map((x) => Gift.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "dateCreated": dateCreated?.toIso8601String(),
    "dateUpdated": dateUpdated?.toIso8601String(),
    "user": user,
    "receiverUser": receiverUser,
    "amount": amount,
    "currentBalanceBeforeTransaction": currentBalanceBeforeTransaction,
    "narration": narration,
    "reference": reference,
    "type": type,
    "transactionDate": transactionDate,
    "createdTime": createdTime,
    "createdDate": createdDate,
    "gifts": gifts == null ? [] : List<dynamic>.from(gifts!.map((x) => x.toJson())),
  };
}

class PaginationControl {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalCount;
  bool? hasPrevious;
  bool? hasNext;

  PaginationControl({
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalCount,
    this.hasPrevious,
    this.hasNext,
  });

  factory PaginationControl.fromJson(Map<String, dynamic> json) => PaginationControl(
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
    pageSize: json["pageSize"],
    totalCount: json["totalCount"],
    hasPrevious: json["hasPrevious"],
    hasNext: json["hasNext"],
  );

  Map<String, dynamic> toJson() => {
    "currentPage": currentPage,
    "totalPages": totalPages,
    "pageSize": pageSize,
    "totalCount": totalCount,
    "hasPrevious": hasPrevious,
    "hasNext": hasNext,
  };
}
