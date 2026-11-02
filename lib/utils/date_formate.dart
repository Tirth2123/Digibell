import 'package:intl/intl.dart';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString); // Parse the incoming date string
  String formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime); // Format to "July 10, 2024"
  return formattedDate;
}
