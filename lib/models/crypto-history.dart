/// ---------------------------
/// TransactionType enum
/// ---------------------------
import 'package:intl/intl.dart';

/// ---------------------------
/// TransactionType enum (fixed)
/// ---------------------------
enum TransactionType {
  deposit(
    label: 'Deposit',
    transPrefix: 'Received',
    suffix: 'from',
  ),
  withdrawal(
    label: 'Withdrawal',
    transPrefix: 'Sent',
    suffix: 'to',
  ),
  swap(
    label: 'Swap',
    transPrefix: 'Swapped',
    suffix: 'into',
  );

  final String label;
  final String transPrefix;
  final String suffix;

  const TransactionType({
    required this.label,
    required this.transPrefix,
    required this.suffix,
  });

  static TransactionType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'withdrawal':
        return TransactionType.withdrawal;
      case 'swap':
        return TransactionType.swap;
      case 'deposit':
      default:
        return TransactionType.deposit;
    }
  }
}

extension TransactionTypeExt on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.swap:
        return 'Swap';
    }
  }

  String get transPrefix {
    switch (this) {
      case TransactionType.deposit:
        return 'Received';
      case TransactionType.withdrawal:
        return 'Sent';
      case TransactionType.swap:
        return 'Swapped';
    }
  }

  String get suffix {
    switch (this) {
      case TransactionType.deposit:
        return 'from';
      case TransactionType.withdrawal:
        return 'to';
      case TransactionType.swap:
        return 'into';
    }
  }
}

/// ---------------------------
/// Unified model for UI display
/// ---------------------------
/// ---------------------------
/// Unified model for UI display
/// ---------------------------
///
GeneralTransaction mapSwapQuotationToGeneralTransaction(Map<String, dynamic> data) {
  return GeneralTransaction(
    id: data['id'] ?? '',
    transactionType: TransactionType.swap, // This is a swap
    currency: data['to_currency']?.toString(),
    amount: data['to_amount']?.toString(),
    status: (data['confirmed'] == true) ? 'Done' : 'Pending',
    txid: data['id']?.toString(),
    createdAt: data['created_at']?.toString(),
    doneAt: data['expires_at']?.toString(),
    description: 'Swap ${data['from_amount']} ${data['from_currency']} to ${data['to_amount']} ${data['to_currency']}',
    senderOrRecipient: data['user']?['email']?.toString(),
    userEmail: data['user']?['email']?.toString(),
    typeAction: 'swap',
    view: data,
  );
}

class GeneralTransaction {
  final String id;
  final TransactionType transactionType;
  final String? currency;
  final String? amount;
  final String? status;
  final String? txid;
  final String? createdAt;
  final String? doneAt;
  final String? description;
  final String? senderOrRecipient; // for deposit/withdrawal
  final String? walletReferenceCurrency;
  final String? walletConvertedBalance;
  final String? userEmail;
  final Map<String, dynamic>? view;
  String? typeAction;

  GeneralTransaction(
      {required this.id,
      required this.transactionType,
      this.currency,
      this.amount,
      this.status,
      this.txid,
      this.createdAt,
      this.doneAt,
      this.description,
      this.senderOrRecipient,
      this.walletReferenceCurrency,
      this.walletConvertedBalance,
      this.userEmail,
      this.typeAction,
      this.view});

  /// 🕓 Format the date for display
  String get formattedDate {
    try {
      final dt = DateTime.parse(createdAt ?? '').toLocal();
      return DateFormat('dd MMM yyyy, h:mm a').format(dt);
    } catch (_) {
      return createdAt ?? '';
    }
  }

  bool get isSuccess => status == "Done";

  /// 🧠 Human-readable description for the UI
  String get descriptionText {
    final prefix = transactionType.transPrefix;
    final suffix = transactionType.suffix;
    final who = senderOrRecipient ?? userEmail ?? 'unknown';
    final amountText = "$amount ${currency?.toUpperCase() ?? ''}";

    switch (transactionType) {
      case TransactionType.deposit:
        return "$prefix $amountText $suffix $who";
      case TransactionType.withdrawal:
        return "$prefix $amountText $suffix $who";
      case TransactionType.swap:
        return "$prefix $amountText $suffix $who";
    }
  }
}

/// ---------------------------
/// Top-level response model
/// ---------------------------
class CryptoTransactionResponse {
  final bool? success;
  final String? message;
  final int? status;
  final int? code;
  final CTransactionModel? data;

  CryptoTransactionResponse({
    this.success,
    this.message,
    this.status,
    this.code,
    this.data,
  });

  factory CryptoTransactionResponse.fromJson(Map<String, dynamic> json) {
    return CryptoTransactionResponse(
      success: json['success'],
      message: json['message'],
      status: json['status'],
      code: json['code'],
      data: json['data'] != null ? CTransactionModel.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'success': success,
      'message': message,
      'status': status,
      'code': code,
    };
    if (data != null) map['data'] = data!.toJson();
    return map;
  }

  /// Unified getter combining all three lists into one sorted list (newest first)
  List<GeneralTransaction> get allTransactions {
    if (data == null) return [];

    final all = <GeneralTransaction>[
      ...?data!.withdrawals?.map((w) => w.toGeneralTransaction()),
      ...?data!.deposits?.map((d) => d.toGeneralTransaction()),
      ...?data!.swapTransactions?.map((s) => s.toGeneralTransaction()),
    ];

    all.sort((a, b) {
      final da = DateTime.tryParse(a.createdAt ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db = DateTime.tryParse(b.createdAt ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da); // newest first
    });

    return all;
  }
}

/// ---------------------------
/// Container for three lists
/// ---------------------------
class CTransactionModel {
  final List<Withdrawal>? withdrawals;
  final List<Deposit>? deposits;
  final List<SwapTransaction>? swapTransactions;

  CTransactionModel({this.withdrawals, this.deposits, this.swapTransactions});

  factory CTransactionModel.fromJson(Map<String, dynamic> json) {
    List<Withdrawal>? parseWithdrawals(dynamic l) => (l as List?)?.map((e) => Withdrawal.fromJson(e)).toList();
    List<Deposit>? parseDeposits(dynamic l) => (l as List?)?.map((e) => Deposit.fromJson(e)).toList();
    List<SwapTransaction>? parseSwaps(dynamic l) => (l as List?)?.map((e) => SwapTransaction.fromJson(e)).toList();

    return CTransactionModel(
      withdrawals: parseWithdrawals(json['withdrawals']),
      deposits: parseDeposits(json['deposits']),
      swapTransactions: parseSwaps(json['swapTransactions']),
    );
  }

  Map<String, dynamic> toJson() => {
        'withdrawals': withdrawals?.map((e) => e.toJson()).toList(),
        'deposits': deposits?.map((e) => e.toJson()).toList(),
        'swapTransactions': swapTransactions?.map((e) => e.toJson()).toList(),
      };
}

///////////////////////////////////////////////////////////////////////////////
/// Withdrawal model & nested objects (matches your JSON)
///////////////////////////////////////////////////////////////////////////////
class Withdrawal {
  final String? id;
  final String? reference;
  final String? type;
  final String? currency;
  final String? amount;
  final String? fee;
  final String? total;
  final String? txid;
  final String? transactionNote;
  final String? narration;
  final String? status;
  final String? reason;
  final String? createdAt;
  final String? doneAt;
  final Recipient? recipient;
  final Wallet? wallet;
  final User? user;

  Withdrawal({
    this.id,
    this.reference,
    this.type,
    this.currency,
    this.amount,
    this.fee,
    this.total,
    this.txid,
    this.transactionNote,
    this.narration,
    this.status,
    this.reason,
    this.createdAt,
    this.doneAt,
    this.recipient,
    this.wallet,
    this.user,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) {
    return Withdrawal(
      id: json['id'],
      reference: json['reference'],
      type: json['type'],
      currency: json['currency'],
      amount: json['amount'],
      fee: json['fee'],
      total: json['total'],
      txid: json['txid'],
      transactionNote: json['transaction_note'],
      narration: json['narration'],
      status: json['status'],
      reason: json['reason'],
      createdAt: json['created_at'],
      doneAt: json['done_at'],
      recipient: json['recipient'] != null ? Recipient.fromJson(json['recipient']) : null,
      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reference': reference,
        'type': type,
        'currency': currency,
        'amount': amount,
        'fee': fee,
        'total': total,
        'txid': txid,
        'transaction_note': transactionNote,
        'narration': narration,
        'status': status,
        'reason': reason,
        'created_at': createdAt,
        'done_at': doneAt,
        'recipient': recipient?.toJson(),
        'wallet': wallet?.toJson(),
        'user': user?.toJson(),
      };

  /// Convert to unified GeneralTransaction
  GeneralTransaction toGeneralTransaction() {
    return GeneralTransaction(
        id: id ?? '',
        transactionType: TransactionType.withdrawal,
        currency: currency,
        amount: amount,
        status: status,
        txid: txid,
        createdAt: createdAt,
        doneAt: doneAt,
        description: 'Withdawal of ${currency?.toUpperCase()} $amount to ${user?.email}', //narration ?? transactionNote ?? '',
        senderOrRecipient: recipient?.details?.userId, // could be internal userId
        walletReferenceCurrency: wallet?.referenceCurrency,
        walletConvertedBalance: wallet?.convertedBalance,
        userEmail: user?.email,
        view: toJson());
  }
}

class Recipient {
  final String? type;
  final RecipientDetails? details;

  Recipient({this.type, this.details});

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        type: json['type'],
        details: json['details'] != null ? RecipientDetails.fromJson(json['details']) : null,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'details': details?.toJson(),
      };
}

class RecipientDetails {
  final String? userId;

  RecipientDetails({this.userId});

  factory RecipientDetails.fromJson(Map<String, dynamic> json) => RecipientDetails(
        userId: json['user_id'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
      };
}

///////////////////////////////////////////////////////////////////////////////
/// Deposit model
///////////////////////////////////////////////////////////////////////////////
class Deposit {
  final String? id;
  final String? type;
  final String? currency;
  final String? amount;
  final String? fee;
  final String? txid;
  final String? status;
  final String? reason;
  final String? createdAt;
  final String? doneAt;
  final Wallet? wallet;
  final User? user;
  final String? sender;
  TransactionType? transactionType;

  Deposit({this.id, this.type, this.currency, this.amount, this.fee, this.txid, this.status, this.reason, this.createdAt, this.doneAt, this.wallet, this.user, this.sender, this.transactionType});

  factory Deposit.fromJson(Map<String, dynamic> json) => Deposit(
      id: json['id'],
      type: json['type'],
      currency: json['currency'],
      amount: json['amount'],
      fee: json['fee'],
      txid: json['txid'],
      status: json['status'],
      reason: json['reason'],
      createdAt: json['created_at'],
      doneAt: json['done_at'],
      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      sender: json['sender'],
      transactionType: json['transaction_type'] != null ? TransactionType.fromString(json['transaction_type']) : null);

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'currency': currency,
        'amount': amount,
        'fee': fee,
        'txid': txid,
        'status': status,
        'reason': reason,
        'created_at': createdAt,
        'done_at': doneAt,
        'wallet': wallet?.toJson(),
        'user': user?.toJson(),
        'sender': sender,
      };

  /// Convert to unified GeneralTransaction
  GeneralTransaction toGeneralTransaction() {
    return GeneralTransaction(
        id: id ?? '',
        transactionType: TransactionType.deposit,
        currency: currency,
        amount: amount,
        status: status,
        txid: txid,
        createdAt: createdAt,
        doneAt: doneAt,
        description: "Received ${currency?.toUpperCase()} $amount from $sender",
        senderOrRecipient: sender,
        walletReferenceCurrency: wallet?.referenceCurrency,
        walletConvertedBalance: wallet?.convertedBalance,
        userEmail: user?.email,
        view: toJson());
  }
}

///////////////////////////////////////////////////////////////////////////////
/// SwapTransaction model (and swap_quotation)
///////////////////////////////////////////////////////////////////////////////
class SwapTransaction {
  final String? id;
  final String? fromCurrency;
  final String? toCurrency;
  final String? fromAmount;
  final String? receivedAmount;
  final String? executionPrice;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final SwapQuotation? swapQuotation;
  final User? user;
  TransactionType? transactionType;

  SwapTransaction(
      {this.id,
      this.fromCurrency,
      this.toCurrency,
      this.fromAmount,
      this.receivedAmount,
      this.executionPrice,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.swapQuotation,
      this.user,
      this.transactionType});

  factory SwapTransaction.fromJson(Map<String, dynamic> json) => SwapTransaction(
      id: json['id'],
      fromCurrency: json['from_currency'],
      toCurrency: json['to_currency'],
      fromAmount: json['from_amount'],
      receivedAmount: json['received_amount'],
      executionPrice: json['execution_price'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      swapQuotation: json['swap_quotation'] != null ? SwapQuotation.fromJson(json['swap_quotation']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      transactionType: json['transaction_type'] != null ? TransactionType.fromString(json['transaction_type']) : null);

  Map<String, dynamic> toJson() => {
        'id': id,
        'from_currency': fromCurrency,
        'to_currency': toCurrency,
        'from_amount': fromAmount,
        'received_amount': receivedAmount,
        'execution_price': executionPrice,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'swap_quotation': swapQuotation?.toJson(),
        'user': user?.toJson(),
        'transaction_type': transactionType?.name
      };

  /// Convert to unified GeneralTransaction
  GeneralTransaction toGeneralTransaction() {
    return GeneralTransaction(
        id: id ?? '',
        transactionType: TransactionType.swap,
        currency: fromCurrency,
        amount: fromAmount,
        status: status,
        txid: null,
        createdAt: createdAt,
        doneAt: updatedAt,
        description: 'Swapped $fromAmount $fromCurrency → $receivedAmount $toCurrency at $executionPrice',
        senderOrRecipient: toCurrency,
        walletReferenceCurrency: null,
        walletConvertedBalance: null,
        userEmail: user?.email,
        view: toJson());
  }
}

class SwapQuotation {
  final String? id;
  final String? fromCurrency;
  final String? toCurrency;
  final String? quotedPrice;
  final String? quotedCurrency;
  final String? fromAmount;
  final String? toAmount;
  final bool? confirmed;
  final String? expiresAt;
  final String? createdAt;
  final String? updatedAt;
  final User? user;

  SwapQuotation({
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

  factory SwapQuotation.fromJson(Map<String, dynamic> json) => SwapQuotation(
        id: json['id'],
        fromCurrency: json['from_currency'],
        toCurrency: json['to_currency'],
        quotedPrice: json['quoted_price'],
        quotedCurrency: json['quoted_currency'],
        fromAmount: json['from_amount'],
        toAmount: json['to_amount'],
        confirmed: json['confirmed'],
        expiresAt: json['expires_at'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        user: json['user'] != null ? User.fromJson(json['user']) : null,
      );

  Map<String, dynamic> toJson() => {
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

///////////////////////////////////////////////////////////////////////////////
/// Wallet, User, Networks (shared nested objects)
///////////////////////////////////////////////////////////////////////////////
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
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json['id'],
        name: json['name'],
        currency: json['currency'],
        balance: json['balance'],
        locked: json['locked'],
        staked: json['staked'],
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        convertedBalance: json['converted_balance'],
        referenceCurrency: json['reference_currency'],
        isCrypto: json['is_crypto'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        blockchainEnabled: json['blockchain_enabled'],
        defaultNetwork: json['default_network'],
        networks: (json['networks'] as List?)?.map((e) => Network.fromJson(e as Map<String, dynamic>)).toList(),
        depositAddress: json['deposit_address'],
        destinationTag: json['destination_tag'],
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
        'networks': networks?.map((e) => e.toJson()).toList(),
        'deposit_address': depositAddress,
        'destination_tag': destinationTag,
      };
}

class Network {
  final String? id;
  final String? name;
  final bool? depositsEnabled;
  final bool? withdrawsEnabled;

  Network({this.id, this.name, this.depositsEnabled, this.withdrawsEnabled});

  factory Network.fromJson(Map<String, dynamic> json) => Network(
        id: json['id'],
        name: json['name'],
        depositsEnabled: json['deposits_enabled'],
        withdrawsEnabled: json['withdraws_enabled'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'deposits_enabled': depositsEnabled,
        'withdraws_enabled': withdrawsEnabled,
      };
}

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
        id: json['id'],
        sn: json['sn'],
        email: json['email'],
        reference: json['reference'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        displayName: json['display_name'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
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
}

///////////////////////////////////////////////////////////////////////////////
/// Utility: safeSublist helper
///////////////////////////////////////////////////////////////////////////////
/// Utility: safe sublist helper (fixed)
List<T> safeSublist<T>(List<T>? list, int start, [int? end]) {
  final l = list ?? [];
  if (l.isEmpty || start >= l.length) return [];

  final safeEnd = (end ?? l.length).clamp(start, l.length);
  return l.sublist(start, safeEnd);
}
