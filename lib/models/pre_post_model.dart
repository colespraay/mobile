// To parse this JSON data, do
//
//     final preOrPostPaidModel = preOrPostPaidModelFromJson(jsonString);

import 'dart:convert';

PreOrPostPaidModel preOrPostPaidModelFromJson(String str) => PreOrPostPaidModel.fromJson(json.decode(str));

String preOrPostPaidModelToJson(PreOrPostPaidModel data) => json.encode(data.toJson());

class PreOrPostPaidModel {
  bool? success;
  int? code;
  String? message;
  List<PrePostDatum>? data;

  PreOrPostPaidModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory PreOrPostPaidModel.fromJson(Map<String, dynamic> json) => PreOrPostPaidModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<PrePostDatum>.from(json["data"]!.map((x) => PrePostDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PrePostDatum {
  String? name;
  String? code;
  int? price;
  String? shortCode;

  PrePostDatum({
    this.name,
    this.code,
    this.price,
    this.shortCode,
  });

  factory PrePostDatum.fromJson(Map<String, dynamic> json) => PrePostDatum(
    name: json["name"],
    code: json["code"],
    price: json["price"],
    shortCode: json["shortCode"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "price": price,
    "shortCode": shortCode,
  };
}
