// To parse this JSON data, do
//
//     final dataPlanModel = dataPlanModelFromJson(jsonString);

import 'dart:convert';

DataPlanModel dataPlanModelFromJson(String str) => DataPlanModel.fromJson(json.decode(str));

String dataPlanModelToJson(DataPlanModel data) => json.encode(data.toJson());

class DataPlanModel {
  bool? success;
  int? code;
  List<DataPlan>? data;
  String? message;

  DataPlanModel({
    this.success,
    this.code,
    this.data,
    this.message,
  });

  factory DataPlanModel.fromJson(Map<String, dynamic> json) => DataPlanModel(
    success: json["success"],
    code: json["code"],
    data: json["data"] == null ? [] : List<DataPlan>.from(json["data"]!.map((x) => DataPlan.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class DataPlan {
  int? id;
  String? billerCode;
  String? name;
  double? defaultCommission;
  DateTime? dateAdded;
  String? country;
  bool? isAirtime;
  String? billerName;
  String? itemCode;
  String? shortName;
  int? fee;
  bool? commissionOnFee;
  String? labelName;
  int? amount;

  DataPlan({
    this.id,
    this.billerCode,
    this.name,
    this.defaultCommission,
    this.dateAdded,
    this.country,
    this.isAirtime,
    this.billerName,
    this.itemCode,
    this.shortName,
    this.fee,
    this.commissionOnFee,
    this.labelName,
    this.amount,
  });

  factory DataPlan.fromJson(Map<String, dynamic> json) => DataPlan(
    id: json["id"],
    billerCode: json["biller_code"],
    name: json["name"],
    defaultCommission: json["default_commission"]?.toDouble(),
    dateAdded: json["date_added"] == null ? null : DateTime.parse(json["date_added"]),
    country: json["country"],
    isAirtime: json["is_airtime"],
    billerName: json["biller_name"],
    itemCode: json["item_code"],
    shortName: json["short_name"],
    fee: json["fee"],
    commissionOnFee: json["commission_on_fee"],
    labelName:json["label_name"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "biller_code": billerCode,
    "name": name,
    "default_commission": defaultCommission,
    "date_added": dateAdded?.toIso8601String(),
    "country": country,
    "is_airtime": isAirtime,
    "biller_name": billerName,
    "item_code": itemCode,
    "short_name": shortName,
    "fee": fee,
    "commission_on_fee": commissionOnFee,
    "label_name": labelName,
    "amount": amount,
  };
}


