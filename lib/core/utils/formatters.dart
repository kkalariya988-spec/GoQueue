import '../constants/app_constants.dart';

/// Formats a whole rupee amount with Indian grouping, e.g. 1299 -> ₹1,299.
String formatInr(num amount) {
  final digits = amount.round().abs().toString();
  final buffer = StringBuffer();

  for (var index = 0; index < digits.length; index++) {
    final remaining = digits.length - index;
    buffer.write(digits[index]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }

  return '${amount < 0 ? '-' : ''}${AppConstants.currency}$buffer';
}

/// Short review/count label, e.g. 932 -> 932 and 1200 -> 1.2k.
String formatCompactCount(int value) {
  if (value >= 1000000) {
    return '${_trimZero(value / 1000000)}m';
  }
  if (value >= 1000) {
    return '${_trimZero(value / 1000)}k';
  }
  return '$value';
}

String _trimZero(double value) {
  final text = value.toStringAsFixed(1);
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}

/// Distance without a trailing .0, e.g. 2.5 -> "2.5" and 3.0 -> "3".
String formatDistance(double kilometres) {
  final text = kilometres.toStringAsFixed(1);
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}
