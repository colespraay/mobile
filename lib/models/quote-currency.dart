class SwapQuotationResponse {
  bool? success;
  int? code;
  String? message;
  SwapQuotationData? data;

  SwapQuotationResponse({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  SwapQuotationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool?;
    code = json['code'] as int?;
    message = json['message'] as String?;
    data = json['data'] != null ? SwapQuotationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'code': code,
      'message': message,
      'data': data?.toJson(),
    };
  }

  SwapQuotationResponse copyWith({
    bool? success,
    int? code,
    String? message,
    SwapQuotationData? data,
  }) {
    return SwapQuotationResponse(
      success: success ?? this.success,
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'SwapQuotationResponse(success: $success, code: $code, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SwapQuotationResponse && other.success == success && other.code == code && other.message == message && other.data == data;
  }

  @override
  int get hashCode {
    return success.hashCode ^ code.hashCode ^ message.hashCode ^ data.hashCode;
  }
}

class SwapQuotationData {
  String? id;
  String? fromCurrency;
  String? toCurrency;
  String? quotedPrice;
  String? quotedCurrency;
  String? fromAmount;
  String? toAmount;
  bool? confirmed;
  String? expiresAt;
  String? createdAt;
  String? updatedAt;
  SwapUser? user;

  SwapQuotationData({
    this.id,
    this.fromCurrency,
    this.toCurrency,
    this.quotedPrice,
    this.quotedCurrency,
    this.fromAmount,
    this.toAmount,
    this.confirmed,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  SwapQuotationData.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    fromCurrency = json['from_currency'] as String?;
    toCurrency = json['to_currency'] as String?;
    quotedPrice = json['quoted_price'] as String?;
    quotedCurrency = json['quoted_currency'] as String?;
    fromAmount = json['from_amount'] as String?;
    toAmount = json['to_amount'] as String?;
    confirmed = json['confirmed'] as bool?;
    expiresAt = json['expires_at'] as String?;
    createdAt = json['created_at'] as String?;
    updatedAt = json['updated_at'] as String?;
    user = json['user'] != null ? SwapUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_currency': fromCurrency,
      'to_currency': toCurrency,
      'quoted_price': quotedPrice,
      'quoted_currency': quotedCurrency,
      'from_amount': fromAmount,
      'to_amount': toAmount,
      'confirmed': confirmed,
      'expires_at': expiresAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
    };
  }

  // Helper methods for numeric conversions
  double? get fromAmountAsDouble => double.tryParse(fromAmount ?? '');
  double? get toAmountAsDouble => double.tryParse(toAmount ?? '');
  double? get quotedPriceAsDouble => double.tryParse(quotedPrice ?? '');
  String get toAmountNotNullable => toAmount ?? "0";
  num get exchangeRate => (toAmountAsDouble ?? 0) / (fromAmountAsDouble ?? 0);
  String get exchangeRateText => "1 $fromCurrency = ${exchangeRate.toStringAsFixed(6)} $toCurrency";
  // Helper to check if quotation is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    try {
      final expiryDate = DateTime.parse(expiresAt!);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return false;
    }
  }

  // Helper to get time remaining until expiry
  Duration? get timeRemaining {
    if (expiresAt == null) return null;
    try {
      final expiryDate = DateTime.parse(expiresAt!);
      return expiryDate.difference(DateTime.now());
    } catch (e) {
      return null;
    }
  }

  SwapQuotationData copyWith({
    String? id,
    String? fromCurrency,
    String? toCurrency,
    String? quotedPrice,
    String? quotedCurrency,
    String? fromAmount,
    String? toAmount,
    bool? confirmed,
    String? expiresAt,
    String? createdAt,
    String? updatedAt,
    SwapUser? user,
  }) {
    return SwapQuotationData(
      id: id ?? this.id,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      quotedPrice: quotedPrice ?? this.quotedPrice,
      quotedCurrency: quotedCurrency ?? this.quotedCurrency,
      fromAmount: fromAmount ?? this.fromAmount,
      toAmount: toAmount ?? this.toAmount,
      confirmed: confirmed ?? this.confirmed,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'SwapQuotationData(id: $id, fromCurrency: $fromCurrency, toCurrency: $toCurrency, fromAmount: $fromAmount, toAmount: $toAmount, confirmed: $confirmed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SwapQuotationData &&
        other.id == id &&
        other.fromCurrency == fromCurrency &&
        other.toCurrency == toCurrency &&
        other.quotedPrice == quotedPrice &&
        other.quotedCurrency == quotedCurrency &&
        other.fromAmount == fromAmount &&
        other.toAmount == toAmount &&
        other.confirmed == confirmed &&
        other.expiresAt == expiresAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fromCurrency.hashCode ^
        toCurrency.hashCode ^
        quotedPrice.hashCode ^
        quotedCurrency.hashCode ^
        fromAmount.hashCode ^
        toAmount.hashCode ^
        confirmed.hashCode ^
        expiresAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        user.hashCode;
  }
}

class SwapUser {
  String? id;
  String? sn;
  String? email;
  String? reference;
  String? firstName;
  String? lastName;
  String? displayName;
  String? createdAt;
  String? updatedAt;

  SwapUser({
    this.id,
    this.sn,
    this.email,
    this.reference,
    this.firstName,
    this.lastName,
    this.displayName,
    this.createdAt,
    this.updatedAt,
  });

  SwapUser.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    sn = json['sn'] as String?;
    email = json['email'] as String?;
    reference = json['reference'] as String?;
    firstName = json['first_name'] as String?;
    lastName = json['last_name'] as String?;
    displayName = json['display_name'] as String?;
    createdAt = json['created_at'] as String?;
    updatedAt = json['updated_at'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sn': sn,
      'email': email,
      'reference': reference,
      'first_name': firstName,
      'last_name': lastName,
      'display_name': displayName,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Helper getter for full name
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    } else {
      return 'Unknown User';
    }
  }

  SwapUser copyWith({
    String? id,
    String? sn,
    String? email,
    String? reference,
    String? firstName,
    String? lastName,
    String? displayName,
    String? createdAt,
    String? updatedAt,
  }) {
    return SwapUser(
      id: id ?? this.id,
      sn: sn ?? this.sn,
      email: email ?? this.email,
      reference: reference ?? this.reference,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'SwapUser(id: $id, email: $email, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SwapUser &&
        other.id == id &&
        other.sn == sn &&
        other.email == email &&
        other.reference == reference &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.displayName == displayName &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ sn.hashCode ^ email.hashCode ^ reference.hashCode ^ firstName.hashCode ^ lastName.hashCode ^ displayName.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
