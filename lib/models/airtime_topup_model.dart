// To parse this JSON data, do
//
//     final airtimeTopUpModelModel = airtimeTopUpModelModelFromJson(jsonString);

import 'dart:convert';

AirtimeTopUpModelModel airtimeTopUpModelModelFromJson(String str) => AirtimeTopUpModelModel.fromJson(json.decode(str));

String airtimeTopUpModelModelToJson(AirtimeTopUpModelModel data) => json.encode(data.toJson());

class AirtimeTopUpModelModel {
  bool? success;
  int? code;
  String? message;
  List<AirtimeTopUpDatum>? data;

  AirtimeTopUpModelModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory AirtimeTopUpModelModel.fromJson(Map<String, dynamic> json) => AirtimeTopUpModelModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<AirtimeTopUpDatum>.from(json["data"]!.map((x) => AirtimeTopUpDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AirtimeTopUpDatum {
  String? name;
  String? code;
  String? displayName;

  AirtimeTopUpDatum({
    this.name,
    this.code,
    this.displayName,
  });

  factory AirtimeTopUpDatum.fromJson(Map<String, dynamic> json) => AirtimeTopUpDatum(
    name: json["name"],
    code: json["code"],
    displayName: json["displayName"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "displayName": displayName,
  };
}
