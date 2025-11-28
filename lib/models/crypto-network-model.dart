class CryptoNetwork {
  String? id;
  String? reference;
  String? currency;
  String? address;
  String? network;
  User? user;
  String? destinationTag;
  String? totalPayments;
  String? createdAt;
  String? updatedAt;

  CryptoNetwork({this.id, this.reference, this.currency, this.address, this.network, this.user, this.destinationTag, this.totalPayments, this.createdAt, this.updatedAt});

  CryptoNetwork.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reference = json['reference'];
    currency = json['currency'];
    address = json['address'];
    network = json['network'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    destinationTag = json['destination_tag'];
    totalPayments = json['total_payments'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reference'] = reference;
    data['currency'] = currency;
    data['address'] = address;
    data['network'] = network;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['destination_tag'] = destinationTag;
    data['total_payments'] = totalPayments;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class User {
  String? id;
  String? sn;
  String? email;
  Null? reference;
  String? firstName;
  String? lastName;
  Null? displayName;
  String? createdAt;
  String? updatedAt;

  User({this.id, this.sn, this.email, this.reference, this.firstName, this.lastName, this.displayName, this.createdAt, this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sn = json['sn'];
    email = json['email'];
    reference = json['reference'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sn'] = sn;
    data['email'] = email;
    data['reference'] = reference;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['display_name'] = displayName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
