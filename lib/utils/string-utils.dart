extension StringExtension on String {
  /// Capitalizes the first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Capitalizes the first letter and makes the rest lowercase
  String capitalizeOnly() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Capitalizes the first letter of each word
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}

String formatMoney(
  dynamic amount, {
  int decimalPlaces = 2,
  String currencySymbol = '',
  String thousandSeparator = ',',
  String decimalSeparator = '.',
  bool showZeroDecimals = false,
}) {
  // Handle null or empty input
  if (amount == null) return '${currencySymbol} 0${decimalSeparator}00';

  // Convert to double
  double value;
  if (amount is String) {
    value = double.tryParse(amount) ?? 0.0;
  } else if (amount is int) {
    value = amount.toDouble();
  } else if (amount is double) {
    value = amount;
  } else {
    value = 0.0;
  }

  // Handle negative numbers
  final isNegative = value < 0;
  final absoluteValue = value.abs();

  // Format the number
  final parts = absoluteValue.toStringAsFixed(decimalPlaces).split('.');
  var integerPart = parts[0];
  var decimalPart = parts[1];

  // Add thousand separators
  final regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  integerPart = integerPart.replaceAllMapped(regExp, (Match match) => '${match[1]}$thousandSeparator');

  // Handle decimal part
  if (!showZeroDecimals && decimalPart == '00') {
    decimalPart = '';
  } else {
    decimalPart = '$decimalSeparator$decimalPart';
  }

  // Build the final string
  final sign = isNegative ? '-' : '';
  final symbol = currencySymbol.isNotEmpty ? '$currencySymbol' : '';

  return '$sign$symbol $integerPart$decimalPart';
}

extension StringFormatExtens on String? {
  /// Formats the string with commas as an amount
  String formatAsAmountWithDecimals() {
    if (this == null || this!.isEmpty) {
      return "0.00";
    }

    try {
      // Remove any existing commas and parse the number
      final number = double.parse(this!.replaceAll(',', ''));
      // Format the number with commas and two decimal places
      final formatted = number.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'\B(?=(\d{3})+(?!\d))'),
            (match) => ',',
          );
      return formatted;
    } catch (e) {
      // If parsing fails, return the original string
      return this!;
    }
  }

  // String formatDate() => DateFormat('dd/MM/yyyy').format(DateTime.parse(this!
  //   // "2024-10-17T14:23:22.956Z"
  // ));
}
