// Import the intl package for formatting
import 'package:intl/intl.dart';

// Define the extension on the String class
extension AmountFormatExtension on String {
  // Method to convert the string to amount format
  String toAmountIntFormat() {
    // Remove any non-digit characters from the string
    String digitsOnly = replaceAll(RegExp(r'[^0-9]'), '');

    // Convert the string to a number
    int amount = int.parse(digitsOnly);

    // Format the number as an amount using the intl package
    final formatter = NumberFormat.decimalPattern();
    return formatter.format(amount);
  }

  String toAmountDoubleFormat() {
    // Remove any non-digit characters from the string
    String digitsOnly = replaceAll(RegExp(r'[^0-9.]'), '');

    // Convert the string to a double
    double amount = double.parse(digitsOnly);

    // Format the number as an amount using the intl package
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: 'N');
    return formatter.format(amount);
  }
}
