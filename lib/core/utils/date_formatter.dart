import 'package:intl/intl.dart';

class AppDateFormatter {
  AppDateFormatter._(); // Private constructor (no instance)

  static final DateFormat _dobFormat = DateFormat('dd MMM yyyy');

  /// Format date for DOB display
  static String formatDOB(DateTime date) {
    return _dobFormat.format(date);
  }

  /// Convert string back to DateTime (if needed)
  static DateTime parseDOB(String dateString) {
    return _dobFormat.parse(dateString);
  }
}