import 'package:intl/intl.dart';

String formatTime(String dateString) {
  DateTime dateTime = DateTime.parse(dateString); // Parse the ISO 8601 date string
  String formattedTime = DateFormat('hh:mm a').format(dateTime.toLocal()); // Format to "12:10 PM"
  return formattedTime;
}
