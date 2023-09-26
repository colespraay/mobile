// To parse this JSON data, do
//
//     final transactionModels = transactionModelsFromJson(jsonString);

import 'dart:convert';

TransactionModels transactionModelsFromJson(String str) => TransactionModels.fromJson(json.decode(str));

String transactionModelsToJson(TransactionModels data) => json.encode(data.toJson());

class TransactionModels {
  bool? success;
  int? code;
  String? message;
  List<DatumTransactionModel>? data;
  PaginationControl? paginationControl;

  TransactionModels({
    this.success,
    this.code,
    this.message,
    this.data,
    this.paginationControl,
  });

  factory TransactionModels.fromJson(Map<String, dynamic> json) => TransactionModels(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<DatumTransactionModel>.from(json["data"]!.map((x) => DatumTransactionModel.fromJson(x))),
    paginationControl: json["paginationControl"] == null ? null : PaginationControl.fromJson(json["paginationControl"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "paginationControl": paginationControl?.toJson(),
  };
}

class DatumTransactionModel {
  String? id;
  bool? status;
  DateTime? dateCreated;
  DateTime? dateUpdated;
  int? amount;
  int? currentBalanceBeforeTransaction;
  String? narration;
  String? reference;
  String? type;
  String? transactionDate;
  String? createdTime;
  String? createdDate;

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
  });

  factory DatumTransactionModel.fromJson(Map<String, dynamic> json) => DatumTransactionModel(
    id: json["id"],
    status: json["status"],
    dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    dateUpdated: json["dateUpdated"] == null ? null : DateTime.parse(json["dateUpdated"]),
    amount: json["amount"],
    currentBalanceBeforeTransaction: json["currentBalanceBeforeTransaction"],
    narration: json["narration"],
    reference: json["reference"],
    type: json["type"],
    transactionDate: json["transactionDate"],
    createdTime: json["createdTime"],
    createdDate: json["createdDate"],
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
  };
}

class PaginationControl {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalCount;
  bool? hasPrevious;
  bool? hasNext;

  PaginationControl({
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalCount,
    this.hasPrevious,
    this.hasNext,
  });

  factory PaginationControl.fromJson(Map<String, dynamic> json) => PaginationControl(
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
    pageSize: json["pageSize"],
    totalCount: json["totalCount"],
    hasPrevious: json["hasPrevious"],
    hasNext: json["hasNext"],
  );

  Map<String, dynamic> toJson() => {
    "currentPage": currentPage,
    "totalPages": totalPages,
    "pageSize": pageSize,
    "totalCount": totalCount,
    "hasPrevious": hasPrevious,
    "hasNext": hasNext,
  };
}
