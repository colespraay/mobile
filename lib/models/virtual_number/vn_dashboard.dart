import 'package:spraay/models/virtual_number/vn_order.dart';

class VnDashboard {
  final double walletBalance;
  final int totalVerifications;
  final int completedVerifications;
  final int cancelledVerifications;
  final List<VnOrder> recentOrders;

  const VnDashboard({
    required this.walletBalance,
    required this.totalVerifications,
    required this.completedVerifications,
    required this.cancelledVerifications,
    required this.recentOrders,
  });

  factory VnDashboard.fromJson(Map<String, dynamic> json) {
    return VnDashboard(
      walletBalance: _toDouble(json['walletBalance']),
      totalVerifications: _toInt(json['totalVerifications']),
      completedVerifications: _toInt(json['completedVerifications']),
      cancelledVerifications: _toInt(json['cancelledVerifications']),
      recentOrders: ((json['recentOrders'] as List?) ?? [])
          .map((e) => VnOrder.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
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
