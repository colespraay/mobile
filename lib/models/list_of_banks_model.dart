// To parse this JSON data, do
//
//     final listOfBankModel = listOfBankModelFromJson(jsonString);

import 'dart:convert';

ListOfBankModel listOfBankModelFromJson(String str) => ListOfBankModel.fromJson(json.decode(str));

String listOfBankModelToJson(ListOfBankModel data) => json.encode(data.toJson());

class ListOfBankModel {
  bool? success;
  int? code;
  String? message;
  List<DatumBankModel>? data;

  ListOfBankModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory ListOfBankModel.fromJson(Map<String, dynamic> json) => ListOfBankModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<DatumBankModel>.from(json["data"]!.map((x) => DatumBankModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DatumBankModel {
  String? bankName;
  String? bankCode;

  DatumBankModel({
    this.bankName,
    this.bankCode,
  });

  factory DatumBankModel.fromJson(Map<String, dynamic> json) => DatumBankModel(
    bankName: json["bankName"],
    bankCode: json["bankCode"],
  );

  Map<String, dynamic> toJson() => {
    "bankName": bankName,
    "bankCode": bankCode,
  };
}
