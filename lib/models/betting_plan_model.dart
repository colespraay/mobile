// To parse this JSON data, do
//
//     final bettingPlanModel = bettingPlanModelFromJson(jsonString);

import 'dart:convert';

BettingPlanModel bettingPlanModelFromJson(String str) => BettingPlanModel.fromJson(json.decode(str));

String bettingPlanModelToJson(BettingPlanModel data) => json.encode(data.toJson());

class BettingPlanModel {
  bool? success;
  int? code;
  String? message;
  List<BettingPlanDatum>? data;

  BettingPlanModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory BettingPlanModel.fromJson(Map<String, dynamic> json) => BettingPlanModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<BettingPlanDatum>.from(json["data"]!.map((x) => BettingPlanDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BettingPlanDatum {
  String? name;
  String? code;
  int? price;
  String? shortCode;

  BettingPlanDatum({
    this.name,
    this.code,
    this.price,
    this.shortCode,
  });

  factory BettingPlanDatum.fromJson(Map<String, dynamic> json) => BettingPlanDatum(
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
