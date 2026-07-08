class VnService {
  final String name;
  final String code;

  const VnService({required this.name, required this.code});

  factory VnService.fromJson(Map<String, dynamic> json) {
    return VnService(
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }

  /// The order/buy endpoints sometimes echo the service back as a bare
  /// code string instead of the {name, code} object used by the catalog
  /// endpoints, so this accepts either shape.
  factory VnService.fromDynamic(dynamic value) {
    if (value is Map) return VnService.fromJson(Map<String, dynamic>.from(value));
    final code = value?.toString() ?? '';
    return VnService(name: code, code: code);
  }

  @override
  bool operator ==(Object other) => other is VnService && other.code == code;

  @override
  int get hashCode => code.hashCode;
}
