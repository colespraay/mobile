import 'package:spraay/models/virtual_number/vn_country.dart';
import 'package:spraay/models/virtual_number/vn_service.dart';

enum VnOrderStatus { pending, waitingSms, received, cancelled, expired, unknown }

extension VnOrderStatusX on VnOrderStatus {
  static VnOrderStatus parse(dynamic raw) {
    final value = raw?.toString().toLowerCase().trim() ?? '';
    if (value.isEmpty) return VnOrderStatus.pending;
    if (value.contains('cancel')) return VnOrderStatus.cancelled;
    if (value.contains('expire') || value.contains('timeout')) return VnOrderStatus.expired;
    if (value.contains('receive') || value.contains('complete') || value.contains('success') || value == 'done') {
      return VnOrderStatus.received;
    }
    if (value.contains('wait') || value.contains('pending') || value.contains('active') || value == '1' || value == '2') {
      return VnOrderStatus.waitingSms;
    }
    return VnOrderStatus.unknown;
  }

  String get label {
    switch (this) {
      case VnOrderStatus.pending:
      case VnOrderStatus.waitingSms:
        return 'Waiting SMS';
      case VnOrderStatus.received:
        return 'Completed';
      case VnOrderStatus.cancelled:
        return 'Cancelled';
      case VnOrderStatus.expired:
        return 'Expired';
      case VnOrderStatus.unknown:
        return 'Unknown';
    }
  }

  bool get isActive => this == VnOrderStatus.pending || this == VnOrderStatus.waitingSms;
}

class VnOrder {
  final String id;
  final VnService service;
  final VnCountry country;
  final String phone;
  final double amountNgn;
  final VnOrderStatus status;
  final String? code;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  const VnOrder({
    required this.id,
    required this.service,
    required this.country,
    required this.phone,
    required this.amountNgn,
    required this.status,
    this.code,
    this.createdAt,
    this.expiresAt,
  });

  int? get secondsLeft {
    final expiry = expiresAt;
    if (expiry == null) return null;
    final diff = expiry.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }

  VnOrder copyWith({VnOrderStatus? status, String? code}) {
    return VnOrder(
      id: id,
      service: service,
      country: country,
      phone: phone,
      amountNgn: amountNgn,
      status: status ?? this.status,
      code: code ?? this.code,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }

  factory VnOrder.fromJson(Map<String, dynamic> json) {
    return VnOrder(
      id: (json['id'] ?? json['_id'] ?? json['orderId'] ?? '').toString(),
      service: json['service'] != null
          ? VnService.fromDynamic(json['service'])
          : VnService(name: (json['serviceName'] ?? '').toString(), code: (json['serviceCode'] ?? '').toString()),
      country: json['country'] != null
          ? VnCountry.fromDynamic(json['country'])
          : VnCountry(name: (json['countryName'] ?? '').toString(), code: (json['countryCode'] ?? '').toString()),
      phone: (json['phone'] ?? json['number'] ?? json['phoneNumber'] ?? '').toString(),
      amountNgn: _toDouble(json['amountNgn'] ?? json['amount'] ?? json['price']),
      status: VnOrderStatusX.parse(json['orderStatus'] ?? json['providerStatus'] ?? json['status']),
      code: (json['code'] ?? json['otp'] ?? json['smsCode'] ?? json['sms'])?.toString(),
      createdAt: _toDate(json['createdAt'] ?? json['created_at'] ?? json['createdTime']),
      expiresAt: _toDate(json['expiresAt'] ?? json['expires_at'] ?? json['expiryDate']),
    );
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

DateTime? _toDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
