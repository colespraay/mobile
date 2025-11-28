// To parse this JSON data, do
//
//     final transactionModels = transactionModelsFromJson(jsonString);

import 'dart:convert';

import 'package:spraay/models/crypto-history.dart';

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
  String? currency;
  String? typeAction;
  String? bankName;
  String? accountName;
  String? accountNumber;

  bool get isCryptoTransaction => (narration ?? "").toLowerCase().contains('swap') || (narration ?? "").toLowerCase().contains('crypto');

  DatumTransactionModel(
      {this.id,
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
      this.currency,
      this.typeAction,
      this.accountName,
      this.bankName,
      this.accountNumber});

  Map<String, dynamic> others() => {
        'Bank Name': bankName,
        'Account Name': accountName,
        'Account Number': accountNumber,
      };

  factory DatumTransactionModel.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return DatumTransactionModel(
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
        typeAction: json['typeAction'],
        currency: json['currency'],
        bankName: json['bankName'],
        accountName: json['accountName'],
        accountNumber: json['accountNumber']);
  }

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
        'typeAction': typeAction,
        'currency': currency,
        'accountName': accountName,
        'accountNumber': accountNumber,
        'bankName': bankName
      };

  @override
  String toString() {
    return 'DatumTransactionModel{id: $id, status: $status, dateCreated: $dateCreated, dateUpdated: $dateUpdated, amount: $amount, currentBalanceBeforeTransaction: $currentBalanceBeforeTransaction, narration: $narration, reference: $reference, type: $type, transactionDate: $transactionDate, createdTime: $createdTime, createdDate: $createdDate, userId: $userId, receiverUserId: $receiverUserId, transactionStatus: $transactionStatus, currency: $currency, typeAction: $typeAction, bankName: $bankName, accountName: $accountName, accountNumber: $accountNumber}';
  }
}

extension ToGeneralTx on DatumTransactionModel {
  GeneralTransaction toGeneralTransaction() {
    // Determine transaction type from the backend `type` or narration
    final normalizedType = (type ?? narration ?? "").toLowerCase();

    final txType = normalizedType.contains("deposit")
        ? TransactionType.deposit
        : normalizedType.contains("withdraw")
            ? TransactionType.withdrawal
            : TransactionType.swap;

    return GeneralTransaction(
        id: id ?? '',
        transactionType: txType,
        currency: currency,
        amount: amount?.toString(),
        status: transactionStatus ?? (status == true ? "Done" : "Failed"),
        txid: reference,
        createdAt: dateCreated?.toIso8601String(),
        doneAt: dateUpdated?.toIso8601String(),
        description: narration,
        senderOrRecipient: receiverUserId?.toString(),
        walletReferenceCurrency: null, // You can wire this when backend supplies it
        walletConvertedBalance: currentBalanceBeforeTransaction?.toString(),
        userEmail: userId,
        view: toJson()
        // {
        //   "transactionDate": transactionDate,
        //   "createdTime": createdTime,
        //   "createdDate": createdDate,
        //   toJson()
        // },
        );
  }

  /// Attempt to guess a currency from the narration e.g. "Sent 100 USDT"
  String? _extractCurrency() {
    final n = narration?.toLowerCase() ?? "";
    final currencies = ["usdt", "btc", "eth", "ltc", "bch", "ngn", "usd"];

    return currencies
        .firstWhere(
          (c) => n.contains(c),
          orElse: () => "",
        )
        .toUpperCase();
  }
}
