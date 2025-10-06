class GCFxRate {
  String? senderCurrency;
  num? senderAmount;
  String? recipientCurrency;
  num? recipientAmount;

  GCFxRate(
      {this.senderCurrency,
      this.senderAmount,
      this.recipientCurrency,
      this.recipientAmount});

  GCFxRate.fromJson(Map<String, dynamic> json) {
    senderCurrency = json['senderCurrency'];
    senderAmount = json['senderAmount'];
    recipientCurrency = json['recipientCurrency'];
    recipientAmount = json['recipientAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderCurrency'] = this.senderCurrency;
    data['senderAmount'] = this.senderAmount;
    data['recipientCurrency'] = this.recipientCurrency;
    data['recipientAmount'] = this.recipientAmount;
    return data;
  }

  @override
  String toString() {
    return 'GCFxRate{senderCurrency: $senderCurrency, senderAmount: $senderAmount, recipientCurrency: $recipientCurrency, recipientAmount: $recipientAmount}';
  }
}
