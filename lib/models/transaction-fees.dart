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

class TransactionFeesData {
  String? depositFee;
  String? cashWithdrawalFee;
  String? cryptoWithdrawalFee;
  String? cryptoswapfee;
  String? swapfee;

  TransactionFeesData({
    this.depositFee,
    this.cashWithdrawalFee,
    this.cryptoWithdrawalFee,
    this.cryptoswapfee,
    this.swapfee,
  });

  TransactionFeesData.fromJson(Map<String, dynamic> json) {
    depositFee = json['depositFee'] as String?;
    cashWithdrawalFee = json['cashWithdrawalFee'] as String?;
    cryptoWithdrawalFee = json['cryptoWithdrawalFee'] as String?;
    cryptoswapfee = json['cryptoswapfee'] as String?;
    swapfee = json['swapfee'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['depositFee'] = depositFee;
    data['cashWithdrawalFee'] = cashWithdrawalFee;
    data['cryptoWithdrawalFee'] = cryptoWithdrawalFee;
    data['cryptoswapfee'] = cryptoswapfee;
    data['swapfee'] = swapfee;
    return data;
  }

  @override
  String toString() {
    return 'TransactionFeesData(depositFee: $depositFee, cashWithdrawalFee: $cashWithdrawalFee, cryptoWithdrawalFee: $cryptoWithdrawalFee, cryptoswapfee: $cryptoswapfee, swapfee: $swapfee)';
  }
}
