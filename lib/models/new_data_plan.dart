// To parse this JSON data, do
//
//     final dataPlanModel = dataPlanModelFromJson(jsonString);

import 'dart:convert';

NewDataPlanModel dataPlanModelFromJson(String str) => NewDataPlanModel.fromJson(json.decode(str));

String dataPlanModelToJson(NewDataPlanModel data) => json.encode(data.toJson());

class  NewDataPlanModel {
  bool? success;
  int? code;
  String? message;
  List<NewDataPlan>? data;

  NewDataPlanModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory NewDataPlanModel.fromJson(Map<String, dynamic> json) => NewDataPlanModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<NewDataPlan>.from(json["data"]!.map((x) => NewDataPlan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NewDataPlan {
  String? validityPeriod;
  int? mobileOperatorId;
  int? servicePrice;
  String? dataValue;
  String? serviceName;
  int? serviceId;

  NewDataPlan({
    this.validityPeriod,
    this.mobileOperatorId,
    this.servicePrice,
    this.dataValue,
    this.serviceName,
    this.serviceId,
  });

  factory NewDataPlan.fromJson(Map<String, dynamic> json) => NewDataPlan(
    validityPeriod: json["validityPeriod"],
    mobileOperatorId: json["mobileOperatorId"],
    servicePrice: json["servicePrice"],
    dataValue: json["dataValue"],
    serviceName: json["serviceName"],
    serviceId: json["serviceId"],
  );

  Map<String, dynamic> toJson() => {
    "validityPeriod": validityPeriod,
    "mobileOperatorId": mobileOperatorId,
    "servicePrice": servicePrice,
    "dataValue": dataValue,
    "serviceName": serviceName,
    "serviceId": serviceId,
  };
}
