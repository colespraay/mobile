// To parse this JSON data, do
//
//     final graphHistoryModel = graphHistoryModelFromJson(jsonString);

import 'dart:convert';

GraphHistoryModel graphHistoryModelFromJson(String str) => GraphHistoryModel.fromJson(json.decode(str));

String graphHistoryModelToJson(GraphHistoryModel data) => json.encode(data.toJson());

class GraphHistoryModel {
  bool? success;
  String? message;
  int? code;
  List<DatumGraphHistory>? data;

  GraphHistoryModel({
    this.success,
    this.message,
    this.code,
    this.data,
  });

  factory GraphHistoryModel.fromJson(Map<String, dynamic> json) => GraphHistoryModel(
    success: json["success"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? [] : List<DatumGraphHistory>.from(json["data"]!.map((x) => DatumGraphHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "code": code,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DatumGraphHistory {
  String? month;
  int? monthCode;
  int? totalAmount;

  DatumGraphHistory({
    this.month,
    this.monthCode,
    this.totalAmount,
  });

  factory DatumGraphHistory.fromJson(Map<String, dynamic> json) => DatumGraphHistory(
    month: json["month"],
    monthCode: json["monthCode"],
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "monthCode": monthCode,
    "totalAmount": totalAmount,
  };
}
