class TransactionFeesResponse {
  bool? success;
  String? message;
  int? status;
  int? code;
  TransactionFeesData? data;

  TransactionFeesResponse({
    this.success,
    this.message,
    this.status,
    this.code,
    this.data,
  });

  TransactionFeesResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool?;
    message = json['message'] as String?;
    status = json['status'] as int?;
    code = json['code'] as int?;
    data = json['data'] != null ? TransactionFeesData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['status'] = status;
    data['code'] = code;
    data['data'] = this.data?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'TransactionFeesResponse(success: $success, message: $message, status: $status, code: $code, data: $data)';
  }
}

// class TransactionFeesData {
//   String? depositFee;
//   String? cashWithdrawalFee;
//   String? cryptoWithdrawalFee;
//   String? cryptoswapfee;
//   String? swapfee;
//
//   TransactionFeesData({
//     this.depositFee,
//     this.cashWithdrawalFee,
//     this.cryptoWithdrawalFee,
//     this.cryptoswapfee,
//     this.swapfee,
//   });
//
//   TransactionFeesData.fromJson(Map<String, dynamic> json) {
//     print(json);
//     depositFee = json['depositFee'] as String?;
//     cashWithdrawalFee = json['cashWithdrawalFee'] as String?;
//     cryptoWithdrawalFee = json['cryptoWithdrawalFee'] as String?;
//     cryptoswapfee = json['cryptoswapfee'] as String?;
//     swapfee = json['swapfee'] as String?;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['depositFee'] = depositFee;
//     data['cashWithdrawalFee'] = cashWithdrawalFee;
//     data['cryptoWithdrawalFee'] = cryptoWithdrawalFee;
//     data['cryptoswapfee'] = cryptoswapfee;
//     data['swapfee'] = swapfee;
//     return data;
//   }
//
//   @override
//   String toString() {
//     return 'TransactionFeesData(depositFee: $depositFee, cashWithdrawalFee: $cashWithdrawalFee, cryptoWithdrawalFee: $cryptoWithdrawalFee, cryptoswapfee: $cryptoswapfee, swapfee: $swapfee)';
//   }
// }
class TransactionFeesData {
  DepositFee? depositFee;
  DepositFee? cashWithdrawalFee;
  DepositFee? cryptoWithdrawalFee;
  DepositFee? cryptoSwapFee;
  DepositFee? swapFee;
  DepositFee? spraayFee;
  DepositFee? rateTopUp;

  TransactionFeesData({this.depositFee, this.cashWithdrawalFee, this.cryptoWithdrawalFee, this.cryptoSwapFee, this.swapFee, this.spraayFee, this.rateTopUp});

  TransactionFeesData.fromJson(Map<String, dynamic> json) {
    depositFee = json['depositFee'] != null ? new DepositFee.fromJson(json['depositFee']) : null;
    cashWithdrawalFee = json['cashWithdrawalFee'] != null ? new DepositFee.fromJson(json['cashWithdrawalFee']) : null;
    cryptoWithdrawalFee = json['cryptoWithdrawalFee'] != null ? new DepositFee.fromJson(json['cryptoWithdrawalFee']) : null;
    cryptoSwapFee = json['cryptoSwapFee'] != null ? new DepositFee.fromJson(json['cryptoSwapFee']) : null;
    swapFee = json['swapFee'] != null ? new DepositFee.fromJson(json['swapFee']) : null;
    spraayFee = json['spraayFee'] != null ? new DepositFee.fromJson(json['spraayFee']) : null;
    rateTopUp = json['rateTopUp'] != null ? new DepositFee.fromJson(json['rateTopUp']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.depositFee != null) {
      data['depositFee'] = this.depositFee!.toJson();
    }
    if (this.cashWithdrawalFee != null) {
      data['cashWithdrawalFee'] = this.cashWithdrawalFee!.toJson();
    }
    if (this.cryptoWithdrawalFee != null) {
      data['cryptoWithdrawalFee'] = this.cryptoWithdrawalFee!.toJson();
    }
    if (this.cryptoSwapFee != null) {
      data['cryptoSwapFee'] = this.cryptoSwapFee!.toJson();
    }
    if (this.swapFee != null) {
      data['swapFee'] = this.swapFee!.toJson();
    }
    if (this.spraayFee != null) {
      data['spraayFee'] = this.spraayFee!.toJson();
    }
    if (this.rateTopUp != null) {
      data['rateTopUp'] = this.rateTopUp!.toJson();
    }
    return data;
  }
}

class DepositFee {
  num? value;
  String? currency;

  String? get fee => (value ?? 0).toString();
  String? get feeAndCurrency => "${(value ?? 0).toString()} ${currency?.toUpperCase()}";

  DepositFee({this.value, this.currency});

  DepositFee.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['currency'] = this.currency;
    return data;
  }
}
