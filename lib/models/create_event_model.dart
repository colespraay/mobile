// To parse this JSON data, do
//
//     final createdEventModel = createdEventModelFromJson(jsonString);

import 'dart:convert';

CreatedEventModel createdEventModelFromJson(String str) => CreatedEventModel.fromJson(json.decode(str));

String createdEventModelToJson(CreatedEventModel data) => json.encode(data.toJson());

class CreatedEventModel {
  bool? success;
  String? message;
  int? code;
  Data? data;

  CreatedEventModel({
    this.success,
    this.message,
    this.code,
    this.data,
  });

  factory CreatedEventModel.fromJson(Map<String, dynamic> json) => CreatedEventModel(
    success: json["success"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "code": code,
    "data": data?.toJson(),
  };
}

class Data {
  String? eventName;
  String? eventDescription;
  DateTime? eventDate;
  String? time;
  String? venue;
  String? category;
  String? eventCoverImage;
  String? userId;
  String? id;
  String? eventCode;
  String? qrCodeForEvent;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;

  Data({
    this.eventName,
    this.eventDescription,
    this.eventDate,
    this.time,
    this.venue,
    this.category,
    this.eventCoverImage,
    this.userId,
    this.id,
    this.eventCode,
    this.qrCodeForEvent,
    this.status,
    this.dateCreated,
    this.dateUpdated,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    eventName: json["eventName"],
    eventDescription: json["eventDescription"],
    eventDate: json["eventDate"] == null ? null : DateTime.parse(json["eventDate"]),
    time: json["time"],
    venue: json["venue"],
    category: json["category"],
    eventCoverImage: json["eventCoverImage"],
    userId: json["userId"],
    id: json["id"],
    eventCode: json["eventCode"],
    qrCodeForEvent: json["qrCodeForEvent"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
  );

  Map<String, dynamic> toJson() => {
    "eventName": eventName,
    "eventDescription": eventDescription,
    "eventDate": "${eventDate!.year.toString().padLeft(4, '0')}-${eventDate!.month.toString().padLeft(2, '0')}-${eventDate!.day.toString().padLeft(2, '0')}",
    "time": time,
    "venue": venue,
    "category": category,
    "eventCoverImage": eventCoverImage,
    "userId": userId,
    "id": id,
    "eventCode": eventCode,
    "qrCodeForEvent": qrCodeForEvent,
    "status": status,
    "dateCreated": dateCreated?.toIso8601String(),
    "dateUpdated": dateUpdated?.toIso8601String(),
  };
}
