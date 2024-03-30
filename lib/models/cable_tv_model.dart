// To parse this JSON data, do
//
//     final cableTvModel = cableTvModelFromJson(jsonString);

import 'dart:convert';

CableTvModel cableTvModelFromJson(String str) => CableTvModel.fromJson(json.decode(str));

String cableTvModelToJson(CableTvModel data) => json.encode(data.toJson());

class CableTvModel {
  bool? success;
  int? code;
  String? message;
  List<CableTvDatum>? data;

  CableTvModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory CableTvModel.fromJson(Map<String, dynamic> json) => CableTvModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<CableTvDatum>.from(json["data"]!.map((x) => CableTvDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CableTvDatum {
  String? name;
  String? code;
  String? displayName;

  CableTvDatum({
    this.name,
    this.code,
    this.displayName,
  });

  factory CableTvDatum.fromJson(Map<String, dynamic> json) => CableTvDatum(
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
