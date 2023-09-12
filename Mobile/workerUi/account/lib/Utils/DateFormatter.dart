import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat(DateFormat().add_yMMMEd().pattern).format(date);
}
