import 'package:spraay/models/virtual_number/vn_order.dart';

class VnOrdersPage {
  final List<VnOrder> orders;
  final int page;
  final int limit;
  final int total;

  const VnOrdersPage({
    required this.orders,
    required this.page,
    required this.limit,
    required this.total,
  });

  bool get hasMore => page * limit < total;

  factory VnOrdersPage.fromJson(Map<String, dynamic> json) {
    return VnOrdersPage(
      orders: ((json['orders'] as List?) ?? [])
          .map((e) => VnOrder.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      page: _toInt(json['page']),
      limit: _toInt(json['limit']),
      total: _toInt(json['total']),
    );
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}
