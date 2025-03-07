// To parse this JSON data, do
//
//     final dataPlanModel = dataPlanModelFromJson(jsonString);

import 'dart:convert';

DataPlanModel dataPlanModelFromJson(String str) => DataPlanModel.fromJson(json.decode(str));

String dataPlanModelToJson(DataPlanModel data) => json.encode(data.toJson());

class DataPlanModel {
  bool? success;
  int? code;
  String? message;
  List<DataPlan>? data;

  DataPlanModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory DataPlanModel.fromJson(Map<String, dynamic> json) => DataPlanModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<DataPlan>.from(json["data"]!.map((x) => DataPlan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DataPlan {
  String? name;
  String? code;
  int? price;
  String? shortCode;

  DataPlan({
    this.name,
    this.code,
    this.price,
    this.shortCode,
  });

  factory DataPlan.fromJson(Map<String, dynamic> json) => DataPlan(
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
