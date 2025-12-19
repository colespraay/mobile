// Response model

class WalletResponse {
  final bool? success;
  final String? message;
  final int? status;
  final int? code;
  final List<Wallet>? data;

  WalletResponse({
    this.success,
    this.message,
    this.status,
    this.code,
    this.data,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
        success: json['success'] as bool?,
        message: json['message'] as String?,
        status: json['status'] as int?,
        code: json['code'] as int?,
        data: json['data'] == null ? null : List<Wallet>.from((json['data'] as List).map((x) => Wallet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'status': status,
        'code': code,
        'data': data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

// Wallet model
class Wallet {
  final String? id;
  final String? name;
  final String? currency;
  final String? balance;
  final String? locked;
  final String? staked;
  final User? user;
  final String? convertedBalance;
  final String? referenceCurrency;
  final bool? isCrypto;
  final String? createdAt;
  final String? updatedAt;
  final bool? blockchainEnabled;
  final String? defaultNetwork;
  final List<Network>? networks;
  final String? depositAddress;
  final String? destinationTag;
  final String? imageUrl;

  Wallet({
    this.id,
    this.name,
    this.currency,
    this.balance,
    this.locked,
    this.staked,
    this.user,
    this.convertedBalance,
    this.referenceCurrency,
    this.isCrypto,
    this.createdAt,
    this.updatedAt,
    this.blockchainEnabled,
    this.defaultNetwork,
    this.networks,
    this.depositAddress,
    this.destinationTag,
    this.imageUrl,
  });

  num get numBalance => num.tryParse(balance ?? "0") ?? 0;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json['id'] as String?,
        name: (json['name'] as String?)?.replaceAll("Wallet", ""),
        currency: json['currency'] as String?,
        balance: json['balance'] as String?,
        locked: json['locked'] as String?,
        staked: json['staked'] as String?,
        user: json['user'] == null ? null : User.fromJson(json['user']),
        convertedBalance: json['converted_balance'] as String?,
        referenceCurrency: json['reference_currency'] as String?,
        isCrypto: json['is_crypto'] as bool?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        blockchainEnabled: json['blockchain_enabled'] as bool?,
        defaultNetwork: json['default_network'] as String?,
        networks: json['networks'] == null ? null : List<Network>.from((json['networks'] as List).map((x) => Network.fromJson(x))),
        depositAddress: json['deposit_address'] as String?,
        destinationTag: json['destination_tag'] as String?,
        imageUrl: json['image_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'currency': currency,
        'balance': balance,
        'locked': locked,
        'staked': staked,
        'user': user?.toJson(),
        'converted_balance': convertedBalance,
        'reference_currency': referenceCurrency,
        'is_crypto': isCrypto,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'blockchain_enabled': blockchainEnabled,
        'default_network': defaultNetwork,
        'networks': networks == null ? null : List<dynamic>.from(networks!.map((x) => x.toJson())),
        'deposit_address': depositAddress,
        'destination_tag': destinationTag,
        'image_url': imageUrl,
      };

  Network? get defaultNetworkObject {
    if (networks == null || defaultNetwork == null) return null;
    try {
      return networks!.firstWhere(
        (network) => network.id?.toLowerCase() == defaultNetwork?.toLowerCase(),
        orElse: () => Network(id: defaultNetwork, name: defaultNetwork?.toUpperCase() ?? ''),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  String toString() {
    return 'Wallet{id: $id, name: $name, currency: $currency, balance: $balance, locked: $locked, staked: $staked, user: ${user.toString()}, convertedBalance: $convertedBalance, referenceCurrency: $referenceCurrency, isCrypto: $isCrypto, createdAt: $createdAt, updatedAt: $updatedAt, blockchainEnabled: $blockchainEnabled, defaultNetwork: $defaultNetwork, networks: ${networks.toString()}, depositAddress: $depositAddress, destinationTag: $destinationTag, imageUrl: $imageUrl}';
  }
}

// User model
class User {
  final String? id;
  final String? sn;
  final String? email;
  final String? reference;
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final String? createdAt;
  final String? updatedAt;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String?,
        sn: json['sn'] as String?,
        email: json['email'] as String?,
        reference: json['reference'] as String?,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        displayName: json['display_name'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
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

  @override
  String toString() {
    return 'User{id: $id, sn: $sn, email: $email, reference: $reference, firstName: $firstName, lastName: $lastName, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

// Network model
class Network {
  final String? id;
  final String? name;
  final bool? depositsEnabled;
  final bool? withdrawsEnabled;

  Network({
    this.id,
    this.name,
    this.depositsEnabled,
    this.withdrawsEnabled,
  });

  factory Network.fromJson(Map<String, dynamic> json) => Network(
        id: json['id'] as String?,
        name: json['name'] as String?,
        depositsEnabled: json['deposits_enabled'] as bool?,
        withdrawsEnabled: json['withdraws_enabled'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'deposits_enabled': depositsEnabled,
        'withdraws_enabled': withdrawsEnabled,
      };

  @override
  String toString() {
    return 'Network{id: $id, name: $name, depositsEnabled: $depositsEnabled, withdrawsEnabled: $withdrawsEnabled}';
  }
}

class MarketData {
  String? coinPair;
  String? baseCoin;
  String? coinName;
  String? lastPrice;
  String? lowestAsk;
  String? highestBid;
  String? baseVolume;
  String? quoteVolume;
  String? priceChangePercent24h;
  String? highestPrice24h;
  String? lowestPrice24h;
  String? logo;

  MarketData({
    this.coinPair,
    this.baseCoin,
    this.coinName,
    this.lastPrice,
    this.lowestAsk,
    this.highestBid,
    this.baseVolume,
    this.quoteVolume,
    this.priceChangePercent24h,
    this.highestPrice24h,
    this.lowestPrice24h,
    this.logo,
  });

  MarketData.fromJson(Map<String, dynamic> json) {
    coinPair = json['coinPair'] as String?;
    baseCoin = json['baseCoin'] as String?;
    coinName = json['coinName'] as String?;
    lastPrice = json['last_price'] as String?;
    lowestAsk = json['lowest_ask'] as String?;
    highestBid = json['highest_bid'] as String?;
    baseVolume = json['base_volume'] as String?;
    quoteVolume = json['quote_volume'] as String?;
    priceChangePercent24h = json['price_change_percent_24h'] as String?;
    highestPrice24h = json['highest_price_24h'] as String?;
    lowestPrice24h = json['lowest_price_24h'] as String?;
    logo = json['logo'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coinPair'] = coinPair;
    data['baseCoin'] = baseCoin;
    data['coinName'] = coinName;
    data['last_price'] = lastPrice;
    data['lowest_ask'] = lowestAsk;
    data['highest_bid'] = highestBid;
    data['base_volume'] = baseVolume;
    data['quote_volume'] = quoteVolume;
    data['price_change_percent_24h'] = priceChangePercent24h;
    data['highest_price_24h'] = highestPrice24h;
    data['lowest_price_24h'] = lowestPrice24h;
    data['logo'] = logo;
    return data;
  }

  MarketData copyWith({
    String? coinPair,
    String? baseCoin,
    String? coinName,
    String? lastPrice,
    String? lowestAsk,
    String? highestBid,
    String? baseVolume,
    String? quoteVolume,
    String? priceChangePercent24h,
    String? highestPrice24h,
    String? lowestPrice24h,
    String? logo,
  }) {
    return MarketData(
      coinPair: coinPair ?? this.coinPair,
      baseCoin: baseCoin ?? this.baseCoin,
      coinName: coinName ?? this.coinName,
      lastPrice: lastPrice ?? this.lastPrice,
      lowestAsk: lowestAsk ?? this.lowestAsk,
      highestBid: highestBid ?? this.highestBid,
      baseVolume: baseVolume ?? this.baseVolume,
      quoteVolume: quoteVolume ?? this.quoteVolume,
      priceChangePercent24h: priceChangePercent24h ?? this.priceChangePercent24h,
      highestPrice24h: highestPrice24h ?? this.highestPrice24h,
      lowestPrice24h: lowestPrice24h ?? this.lowestPrice24h,
      logo: logo ?? this.logo,
    );
  }

  // Helper method to get numeric values for calculations
  double? get lastPriceAsDouble => double.tryParse(lastPrice ?? '');
  double? get priceChangePercentAsDouble => double.tryParse(priceChangePercent24h ?? '');
  double? get baseVolumeAsDouble => double.tryParse(baseVolume ?? '');

  // Helper to check if price change is positive
  bool get isPricePositive {
    final percent = priceChangePercentAsDouble;
    if (percent == null) return false;
    return percent > 0;
  }

  // Helper to check if price change is negative
  bool get isPriceNegative {
    final percent = priceChangePercentAsDouble;
    if (percent == null) return false;
    return percent < 0;
  }

  @override
  String toString() {
    return 'MarketData(coinPair: $coinPair, baseCoin: $baseCoin, coinName: $coinName, lastPrice: $lastPrice, priceChangePercent24h: $priceChangePercent24h)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MarketData &&
        other.coinPair == coinPair &&
        other.baseCoin == baseCoin &&
        other.coinName == coinName &&
        other.lastPrice == lastPrice &&
        other.lowestAsk == lowestAsk &&
        other.highestBid == highestBid &&
        other.baseVolume == baseVolume &&
        other.quoteVolume == quoteVolume &&
        other.priceChangePercent24h == priceChangePercent24h &&
        other.highestPrice24h == highestPrice24h &&
        other.lowestPrice24h == lowestPrice24h &&
        other.logo == logo;
  }

  @override
  int get hashCode {
    return coinPair.hashCode ^
        baseCoin.hashCode ^
        coinName.hashCode ^
        lastPrice.hashCode ^
        lowestAsk.hashCode ^
        highestBid.hashCode ^
        baseVolume.hashCode ^
        quoteVolume.hashCode ^
        priceChangePercent24h.hashCode ^
        highestPrice24h.hashCode ^
        lowestPrice24h.hashCode ^
        logo.hashCode;
  }

  String get imageUrl => logo ?? "";
  String get name => coinName ?? "";
  String get currency => baseCoin ?? "";

  String get referenceCurrency => (coinPair ?? "").split("_")[1];

  num get numBalance => 0;
}
