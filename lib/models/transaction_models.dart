// To parse this JSON data, do
//
//     final transactionModels = transactionModelsFromJson(jsonString);

import 'dart:convert';

TransactionModels transactionModelsFromJson(String str) => TransactionModels.fromJson(json.decode(str));

String transactionModelsToJson(TransactionModels data) => json.encode(data.toJson());

class TransactionModels {
  bool? success;
  String? message;
  int? code;
  List<DatumTransactionModel>? data;

  TransactionModels({
    this.success,
    this.message,
    this.code,
    this.data,
  });

  factory TransactionModels.fromJson(Map<String, dynamic> json) => TransactionModels(
    success: json["success"],
    message: json["message"],
    code: json["code"],
    data: json["data"] == null ? [] : List<DatumTransactionModel>.from(json["data"]!.map((x) => DatumTransactionModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "code": code,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DatumTransactionModel {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  double? amount;
  double? currentBalanceBeforeTransaction;
  String? narration;
  String? reference;
  String? type;
  String? transactionDate;
  String? createdTime;
  String? createdDate;
  String? userId;
  dynamic receiverUserId;
  String? transactionStatus;

  DatumTransactionModel({
    this.id,
    this.status,
    this.dateCreated,
    this.dateUpdated,
    this.amount,
    this.currentBalanceBeforeTransaction,
    this.narration,
    this.reference,
    this.type,
    this.transactionDate,
    this.createdTime,
    this.createdDate,
    this.userId,
    this.receiverUserId,
    this.transactionStatus,
  });

  factory DatumTransactionModel.fromJson(Map<String, dynamic> json) => DatumTransactionModel(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    amount: json["amount"]?.toDouble(),
    currentBalanceBeforeTransaction: json["currentBalanceBeforeTransaction"]?.toDouble(),
    narration: json["narration"],
    reference: json["reference"],
    type: json["type"],
    transactionDate: json["transactionDate"],
    createdTime: json["createdTime"],
    createdDate: json["createdDate"],
    userId: json["userId"],
    receiverUserId: json["receiverUserId"],
    transactionStatus: json["transactionStatus"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "dateCreated": dateCreated?.toIso8601String(),
    "dateUpdated": dateUpdated?.toIso8601String(),
    "amount": amount,
    "currentBalanceBeforeTransaction": currentBalanceBeforeTransaction,
    "narration": narration,
    "reference": reference,
    "type": type,
    "transactionDate": transactionDate,
    "createdTime": createdTime,
    "createdDate": createdDate,
    "userId": userId,
    "receiverUserId": receiverUserId,
    "transactionStatus": transactionStatus,
  };
}