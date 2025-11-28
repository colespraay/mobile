class CryptoTransactionResponse {
  bool? success;
  String? message;
  int? status;
  int? code;
  CTransactionModel? data;

  CryptoTransactionResponse({this.success, this.message, this.status, this.code, this.data});

  CryptoTransactionResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? CTransactionModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CTransactionModel {
  List<CTransaction>? withdrawals;
  List<CTransaction>? deposits;
  List<CTransaction>? swapTransactions;

  CTransactionModel({this.withdrawals, this.deposits, this.swapTransactions});

  CTransactionModel.fromJson(Map<String, dynamic> json) {
    if (json['withdrawals'] != null) {
      withdrawals = (json['withdrawals'] as List).map((v) => CTransaction.fromJson(v, type: TransactionType.withdrawal)).toList();
    }
    if (json['deposits'] != null) {
      deposits = (json['deposits'] as List).map((v) => CTransaction.fromJson(v, type: TransactionType.deposit)).toList();
    }
    if (json['swapTransactions'] != null) {
      swapTransactions = (json['swapTransactions'] as List).map((v) => CTransaction.fromJson(v, type: TransactionType.swap)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (withdrawals != null) {
      data['withdrawals'] = withdrawals!.map((v) => v.toJson()).toList();
    }
    if (deposits != null) {
      data['deposits'] = deposits!.map((v) => v.toJson()).toList();
    }
    if (swapTransactions != null) {
      data['swapTransactions'] = swapTransactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  /// 🔹 Returns all transactions combined, sorted by creation date (optional)
  List<CTransaction> get allTransactions {
    final all = <CTransaction>[
      ...?withdrawals,
      ...?deposits,
      ...?swapTransactions,
    ];

    all.sort((a, b) {
      final aDate = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(0);
      final bDate = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(0);
      return bDate.compareTo(aDate); // newest first
    });

    return all;
  }
}

class CTransaction {
  String? id;
  String? type;
  String? currency;
  String? amount;
  String? fee;
  String? txid;
  String? status;
  String? reason;
  String? createdAt;
  String? doneAt;
  CWallet? wallet;
  CUser? user;
  String? sender;
  TransactionType? transactionType;

  CTransaction({
    this.id,
    this.type,
    this.currency,
    this.amount,
    this.fee,
    this.txid,
    this.status,
    this.reason,
    this.createdAt,
    this.doneAt,
    this.wallet,
    this.user,
    this.sender,
    this.transactionType,
  });

  CTransaction.fromJson(Map<String, dynamic> json, {TransactionType? type}) {
    id = json['id'];
    this.type = json['type'];
    currency = json['currency'];
    amount = json['amount'];
    fee = json['fee'];
    txid = json['txid'];
    status = json['status'];
    reason = json['reason'];
    createdAt = json['created_at'];
    doneAt = json['done_at'];
    wallet = json['wallet'] != null ? CWallet.fromJson(json['wallet']) : null;
    user = json['user'] != null ? CUser.fromJson(json['user']) : null;
    sender = json['sender'];
    transactionType = type; // 🔹 assign when parsing
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['currency'] = currency;
    data['amount'] = amount;
    data['fee'] = fee;
    data['txid'] = txid;
    data['status'] = status;
    data['reason'] = reason;
    data['created_at'] = createdAt;
    data['done_at'] = doneAt;
    if (wallet != null) data['wallet'] = wallet!.toJson();
    if (user != null) data['user'] = user!.toJson();
    data['sender'] = sender;
    data['transaction_type'] = transactionType.toString().split('.').last;
    return data;
  }

  @override
  String toString() {
    return 'CTransaction{id: $id, type: $type, currency: $currency, amount: $amount, fee: $fee, txid: $txid, status: $status, reason: $reason, createdAt: $createdAt, doneAt: $doneAt, wallet: ${wallet.toString()}, user: ${user.toString()}, sender: $sender, transactionType: ${transactionType.toString()}}';
  }
}

class CWallet {
  String? id;
  String? name;
  String? currency;
  String? balance;
  String? locked;
  String? staked;
  CUser? user;
  String? convertedBalance;
  String? referenceCurrency;
  bool? isCrypto;
  String? createdAt;
  String? updatedAt;
  bool? blockchainEnabled;
  String? defaultNetwork;
  List<CNetworks>? networks;
  String? depositAddress;
  String? destinationTag;

  CWallet(
      {this.id,
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
      this.destinationTag});

  CWallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    currency = json['currency'];
    balance = json['balance'];
    locked = json['locked'];
    staked = json['staked'];
    user = json['user'] != null ? CUser.fromJson(json['user']) : null;
    convertedBalance = json['converted_balance'];
    referenceCurrency = json['reference_currency'];
    isCrypto = json['is_crypto'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    blockchainEnabled = json['blockchain_enabled'];
    defaultNetwork = json['default_network'];
    if (json['networks'] != null) {
      networks = <CNetworks>[];
      json['networks'].forEach((v) {
        networks!.add(CNetworks.fromJson(v));
      });
    }
    depositAddress = json['deposit_address'];
    destinationTag = json['destination_tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['currency'] = currency;
    data['balance'] = balance;
    data['locked'] = locked;
    data['staked'] = staked;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['converted_balance'] = convertedBalance;
    data['reference_currency'] = referenceCurrency;
    data['is_crypto'] = isCrypto;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['blockchain_enabled'] = blockchainEnabled;
    data['default_network'] = defaultNetwork;
    if (networks != null) {
      data['networks'] = networks!.map((v) => v.toJson()).toList();
    }
    data['deposit_address'] = depositAddress;
    data['destination_tag'] = destinationTag;
    return data;
  }

  @override
  String toString() {
    return 'CWallet{id: $id, name: $name, currency: $currency, balance: $balance, locked: $locked, staked: $staked, user: ${user.toString()}, convertedBalance: $convertedBalance, referenceCurrency: $referenceCurrency, isCrypto: $isCrypto, createdAt: $createdAt, updatedAt: $updatedAt, blockchainEnabled: $blockchainEnabled, defaultNetwork: $defaultNetwork, networks: ${networks.toString()}, depositAddress: $depositAddress, destinationTag: $destinationTag}';
  }
}

class CUser {
  String? id;
  String? sn;
  String? email;
  String? reference;
  String? firstName;
  String? lastName;
  String? displayName;
  String? createdAt;
  String? updatedAt;

  CUser({this.id, this.sn, this.email, this.reference, this.firstName, this.lastName, this.displayName, this.createdAt, this.updatedAt});

  CUser.fromJson(Map<String, dynamic> json) {
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

  @override
  String toString() {
    return 'CUser{id: $id, sn: $sn, email: $email, reference: $reference, firstName: $firstName, lastName: $lastName, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

class CNetworks {
  String? id;
  String? name;
  bool? depositsEnabled;
  bool? withdrawsEnabled;

  CNetworks({this.id, this.name, this.depositsEnabled, this.withdrawsEnabled});

  CNetworks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    depositsEnabled = json['deposits_enabled'];
    withdrawsEnabled = json['withdraws_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['deposits_enabled'] = depositsEnabled;
    data['withdraws_enabled'] = withdrawsEnabled;
    return data;
  }

  @override
  String toString() {
    return 'CNetworks{id: $id, name: $name, depositsEnabled: $depositsEnabled, withdrawsEnabled: $withdrawsEnabled}';
  }
}

enum TransactionType {
  deposit(transPrefix: "Received", suffix: 'from'),
  withdrawal(transPrefix: "Sent", suffix: "to"),
  swap(transPrefix: "Swapped", suffix: 'with');

  final String? transPrefix, suffix;
  const TransactionType({this.transPrefix, this.suffix});
}
