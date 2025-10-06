class GiftCardReq {
  num? productId;
  num? quantity;
  num? unitPrice;
  String? senderName;
  String? recipientEmail;
  bool? preOrder;
  String? customIdentifier;
  String? transactionPin;
  String? userid;

  GiftCardReq({this.productId, this.quantity, this.unitPrice, this.senderName, this.recipientEmail, this.preOrder, this.customIdentifier, this.transactionPin, this.userid});

  GiftCardReq.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    senderName = json['senderName'];
    recipientEmail = json['recipientEmail'];
    preOrder = json['preOrder'];
    customIdentifier = json['customIdentifier'];
    transactionPin = json['transactionPin'];
    userid = json['userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['quantity'] = quantity;
    data['unitPrice'] = unitPrice;
    data['senderName'] = senderName;
    data['recipientEmail'] = recipientEmail;
    data['preOrder'] = preOrder;
    data['customIdentifier'] = customIdentifier;
    data['transactionPin'] = transactionPin;
    data['userid'] = userid;
    return data;
  }
}
