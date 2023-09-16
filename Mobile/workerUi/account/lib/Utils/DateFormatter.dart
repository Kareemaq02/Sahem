import 'package:intl/intl.dart';
// ignore_for_file: file_names


String formatDate(DateTime date) {
  return DateFormat(DateFormat().add_yMMMEd().pattern).format(date);
}
