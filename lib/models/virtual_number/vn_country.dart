class VnCountry {
  final String name;
  final String code;

  const VnCountry({required this.name, required this.code});

  factory VnCountry.fromJson(Map<String, dynamic> json) {
    return VnCountry(
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }

  /// The order/buy endpoints sometimes echo the country back as a bare
  /// code string instead of the {name, code} object used by the catalog
  /// endpoints, so this accepts either shape.
  factory VnCountry.fromDynamic(dynamic value) {
    if (value is Map) return VnCountry.fromJson(Map<String, dynamic>.from(value));
    final code = value?.toString() ?? '';
    return VnCountry(name: code, code: code);
  }

  @override
  bool operator ==(Object other) => other is VnCountry && other.code == code;

  @override
  int get hashCode => code.hashCode;
}
