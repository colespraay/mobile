import 'package:spraay/models/virtual_number/vn_country.dart';
import 'package:spraay/models/virtual_number/vn_service.dart';

class VnPrice {
  final VnService service;
  final VnCountry country;
  final double providerCostUsd;
  final double markupUsd;
  final double totalUsd;
  final double fxRate;
  final double amountNgn;
  final int available;

  const VnPrice({
    required this.service,
    required this.country,
    required this.providerCostUsd,
    required this.markupUsd,
    required this.totalUsd,
    required this.fxRate,
    required this.amountNgn,
    required this.available,
  });

  factory VnPrice.fromJson(Map<String, dynamic> json) {
    return VnPrice(
      service: VnService.fromJson(Map<String, dynamic>.from(json['service'] ?? {})),
      country: VnCountry.fromJson(Map<String, dynamic>.from(json['country'] ?? {})),
      providerCostUsd: _toDouble(json['providerCostUsd']),
      markupUsd: _toDouble(json['markupUsd']),
      totalUsd: _toDouble(json['totalUsd']),
      fxRate: _toDouble(json['fxRate']),
      amountNgn: _toDouble(json['amountNgn']),
      available: _toInt(json['available']),
    );
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}
