class GiftCardCountry {
  String? isoName;
  String? name;
  String? currencyCode;
  String? currencyName;
  String? flagUrl;

  GiftCardCountry(
      {this.isoName,
      this.name,
      this.currencyCode,
      this.currencyName,
      this.flagUrl});

  GiftCardCountry.fromJson(Map<String, dynamic> json) {
    isoName = json['isoName'];
    name = json['name'];
    currencyCode = json['currencyCode'];
    currencyName = json['currencyName'];
    flagUrl = json['flagUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isoName'] = this.isoName;
    data['name'] = this.name;
    data['currencyCode'] = this.currencyCode;
    data['currencyName'] = this.currencyName;
    data['flagUrl'] = this.flagUrl;
    return data;
  }
}
