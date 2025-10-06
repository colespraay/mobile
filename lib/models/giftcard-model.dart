class SingleGiftCardModel {
  num? productId;
  String? productName;
  bool? global;
  String? status;
  bool? supportsPreOrder;
  num? senderFee;
  num? senderFeePercentage;
  num? discountPercentage;
  String? denominationType;
  String? recipientCurrencyCode;
  num? minRecipientDenomination;
  num? maxRecipientDenomination;
  String? senderCurrencyCode;
  num? minSenderDenomination;
  num? maxSenderDenomination;
  List<num>? fixedRecipientDenominations;
  List<num>? fixedSenderDenominations;
  Map<dynamic, dynamic>? fixedRecipientToSenderDenominationsMap;
  Map<dynamic, dynamic>? metadata;
  List<String>? logoUrls;
  Brand? brand;
  Category? category;
  Country? country;
  RedeemInstruction? redeemInstruction;
  AdditionalRequirements? additionalRequirements;

  SingleGiftCardModel(
      {this.productId,
      this.productName,
      this.global,
      this.status,
      this.supportsPreOrder,
      this.senderFee,
      this.senderFeePercentage,
      this.discountPercentage,
      this.denominationType,
      this.recipientCurrencyCode,
      this.minRecipientDenomination,
      this.maxRecipientDenomination,
      this.senderCurrencyCode,
      this.minSenderDenomination,
      this.maxSenderDenomination,
      this.fixedRecipientDenominations,
      this.fixedSenderDenominations,
      this.fixedRecipientToSenderDenominationsMap,
      this.metadata,
      this.logoUrls,
      this.brand,
      this.category,
      this.country,
      this.redeemInstruction,
      this.additionalRequirements});

  SingleGiftCardModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    global = json['global'];
    status = json['status'];
    supportsPreOrder = json['supportsPreOrder'];
    senderFee = json['senderFee'];
    senderFeePercentage = json['senderFeePercentage'];
    discountPercentage = json['discountPercentage'];
    denominationType = json['denominationType'];
    recipientCurrencyCode = json['recipientCurrencyCode'];
    minRecipientDenomination = json['minRecipientDenomination'];
    maxRecipientDenomination = json['maxRecipientDenomination'];
    senderCurrencyCode = json['senderCurrencyCode'];
    minSenderDenomination = json['minSenderDenomination'];
    maxSenderDenomination = json['maxSenderDenomination'];
    fixedRecipientDenominations = List<num>.from(json["fixedRecipientDenominations"].map((x) => x));
    fixedSenderDenominations = json["fixedSenderDenominations"] == null ? [] : List<num>.from(json["fixedSenderDenominations"]!.map((x) => x));
    fixedRecipientToSenderDenominationsMap = json['fixedRecipientToSenderDenominationsMap'] != null ? json['fixedRecipientToSenderDenominationsMap'] : null;
    metadata = json['metadata'] != null ? json['metadata'] : null;
    logoUrls = json['logoUrls'].cast<String>();
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    redeemInstruction = json['redeemInstruction'] != null ? RedeemInstruction.fromJson(json['redeemInstruction']) : null;
    additionalRequirements = json['additionalRequirements'] != null ? AdditionalRequirements.fromJson(json['additionalRequirements']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['global'] = global;
    data['status'] = status;
    data['supportsPreOrder'] = supportsPreOrder;
    data['senderFee'] = senderFee;
    data['senderFeePercentage'] = senderFeePercentage;
    data['discountPercentage'] = discountPercentage;
    data['denominationType'] = denominationType;
    data['recipientCurrencyCode'] = recipientCurrencyCode;
    data['minRecipientDenomination'] = minRecipientDenomination;
    data['maxRecipientDenomination'] = maxRecipientDenomination;
    data['senderCurrencyCode'] = senderCurrencyCode;
    data['minSenderDenomination'] = minSenderDenomination;
    data['maxSenderDenomination'] = maxSenderDenomination;
    data['fixedRecipientDenominations'] = fixedRecipientDenominations;
    data['fixedSenderDenominations'] = fixedSenderDenominations;
    if (fixedRecipientToSenderDenominationsMap != null) {
      data['fixedRecipientToSenderDenominationsMap'] = fixedRecipientToSenderDenominationsMap;
    }
    if (metadata != null) {
      data['metadata'] = metadata;
    }
    data['logoUrls'] = logoUrls;
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (country != null) {
      data['country'] = country!.toJson();
    }
    if (redeemInstruction != null) {
      data['redeemInstruction'] = redeemInstruction!.toJson();
    }
    if (additionalRequirements != null) {
      data['additionalRequirements'] = additionalRequirements!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'SingleGiftCardModel{productId: $productId, productName: $productName, global: $global, supportsPreOrder: $supportsPreOrder, senderFee: $senderFee, senderFeePercentage: $senderFeePercentage, discountPercentage: $discountPercentage, denominationType: $denominationType, recipientCurrencyCode: $recipientCurrencyCode, minRecipientDenomination: $minRecipientDenomination, maxRecipientDenomination: $maxRecipientDenomination, senderCurrencyCode: $senderCurrencyCode, minSenderDenomination: $minSenderDenomination, maxSenderDenomination: $maxSenderDenomination, fixedRecipientDenominations: $fixedRecipientDenominations, fixedSenderDenominations: $fixedSenderDenominations, fixedRecipientToSenderDenominationsMap: $fixedRecipientToSenderDenominationsMap, metadata: ${metadata.toString()}, logoUrls: $logoUrls, brand: ${brand.toString()}, category: ${category.toString()}, country: ${country.toString()}, redeemInstruction: ${redeemInstruction.toString()}}';
  }
}

class Brand {
  num? brandId;
  String? brandName;

  Brand({this.brandId, this.brandName});

  Brand.fromJson(Map<String, dynamic> json) {
    brandId = json['brandId'];
    brandName = json['brandName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brandId'] = brandId;
    data['brandName'] = brandName;
    return data;
  }

  @override
  String toString() {
    return 'Brand{brandId: $brandId, brandName: $brandName}';
  }
}

class Category {
  num? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name}';
  }
}

class Country {
  String? isoName;
  String? name;
  String? flagUrl;

  Country({this.isoName, this.name, this.flagUrl});

  Country.fromJson(Map<String, dynamic> json) {
    isoName = json['isoName'];
    name = json['name'];
    flagUrl = json['flagUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isoName'] = isoName;
    data['name'] = name;
    data['flagUrl'] = flagUrl;
    return data;
  }

  @override
  String toString() {
    return 'Country{isoName: $isoName, name: $name, flagUrl: $flagUrl}';
  }
}

class RedeemInstruction {
  String? concise;
  String? verbose;

  RedeemInstruction({this.concise, this.verbose});

  RedeemInstruction.fromJson(Map<String, dynamic> json) {
    concise = json['concise'];
    verbose = json['verbose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['concise'] = concise;
    data['verbose'] = verbose;
    return data;
  }

  @override
  String toString() {
    return 'RedeemInstruction{concise: $concise, verbose: $verbose}';
  }
}

class AdditionalRequirements {
  bool? userIdRequired;

  AdditionalRequirements({this.userIdRequired});

  AdditionalRequirements.fromJson(Map<String, dynamic> json) {
    userIdRequired = json['userIdRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userIdRequired'] = this.userIdRequired;
    return data;
  }
}

class Data {
  num? productId;
  String? productName;
  bool? global;
  String? status;
  bool? supportsPreOrder;
  num? senderFee;
  num? senderFeePercentage;
  double? discountPercentage;
  String? denominationType;
  String? recipientCurrencyCode;
  num? minRecipientDenomination;
  num? maxRecipientDenomination;
  String? senderCurrencyCode;
  num? minSenderDenomination;
  num? maxSenderDenomination;
  List<num>? fixedRecipientDenominations;
  List<num>? fixedSenderDenominations;
  Map<dynamic, dynamic>? fixedRecipientToSenderDenominationsMap;
  Map<dynamic, dynamic>? metadata;
  List<String>? logoUrls;
  Brand? brand;
  Category? category;
  Country? country;
  RedeemInstruction? redeemInstruction;
  AdditionalRequirements? additionalRequirements;

  Data(
      {this.productId,
      this.productName,
      this.global,
      this.status,
      this.supportsPreOrder,
      this.senderFee,
      this.senderFeePercentage,
      this.discountPercentage,
      this.denominationType,
      this.recipientCurrencyCode,
      this.minRecipientDenomination,
      this.maxRecipientDenomination,
      this.senderCurrencyCode,
      this.minSenderDenomination,
      this.maxSenderDenomination,
      this.fixedRecipientDenominations,
      this.fixedSenderDenominations,
      this.fixedRecipientToSenderDenominationsMap,
      this.metadata,
      this.logoUrls,
      this.brand,
      this.category,
      this.country,
      this.redeemInstruction,
      this.additionalRequirements});

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    global = json['global'];
    status = json['status'];
    supportsPreOrder = json['supportsPreOrder'];
    senderFee = json['senderFee'];
    senderFeePercentage = json['senderFeePercentage'];
    discountPercentage = json['discountPercentage'];
    denominationType = json['denominationType'];
    recipientCurrencyCode = json['recipientCurrencyCode'];
    minRecipientDenomination = json['minRecipientDenomination'];
    maxRecipientDenomination = json['maxRecipientDenomination'];
    senderCurrencyCode = json['senderCurrencyCode'];
    minSenderDenomination = json['minSenderDenomination'];
    maxSenderDenomination = json['maxSenderDenomination'];
    fixedRecipientDenominations = json['fixedRecipientDenominations'].cast<num>();
    fixedSenderDenominations = json['fixedSenderDenominations'].cast<num>();
    fixedRecipientToSenderDenominationsMap = json['fixedRecipientToSenderDenominationsMap'] != null ? json['fixedRecipientToSenderDenominationsMap'] : null;
    metadata = json['metadata'] != null ? json['metadata'] : null;
    logoUrls = json['logoUrls'].cast<String>();
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    redeemInstruction = json['redeemInstruction'] != null ? RedeemInstruction.fromJson(json['redeemInstruction']) : null;
    additionalRequirements = json['additionalRequirements'] != null ? AdditionalRequirements.fromJson(json['additionalRequirements']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['global'] = global;
    data['status'] = status;
    data['supportsPreOrder'] = supportsPreOrder;
    data['senderFee'] = senderFee;
    data['senderFeePercentage'] = senderFeePercentage;
    data['discountPercentage'] = discountPercentage;
    data['denominationType'] = denominationType;
    data['recipientCurrencyCode'] = recipientCurrencyCode;
    data['minRecipientDenomination'] = minRecipientDenomination;
    data['maxRecipientDenomination'] = maxRecipientDenomination;
    data['senderCurrencyCode'] = senderCurrencyCode;
    data['minSenderDenomination'] = minSenderDenomination;
    data['maxSenderDenomination'] = maxSenderDenomination;
    data['fixedRecipientDenominations'] = fixedRecipientDenominations;
    data['fixedSenderDenominations'] = fixedSenderDenominations;
    if (fixedRecipientToSenderDenominationsMap != null) {
      data['fixedRecipientToSenderDenominationsMap'] = fixedRecipientToSenderDenominationsMap;
    }
    if (metadata != null) {
      data['metadata'] = metadata;
    }
    data['logoUrls'] = logoUrls;
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (country != null) {
      data['country'] = country!.toJson();
    }
    if (redeemInstruction != null) {
      data['redeemInstruction'] = redeemInstruction!.toJson();
    }
    if (additionalRequirements != null) {
      data['additionalRequirements'] = additionalRequirements!.toJson();
    }
    return data;
  }
}
