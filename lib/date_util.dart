import 'package:intl/intl.dart';

String dateFormatYMMDToString(DateTime date) {
  return DateFormat.yMMMd().format(date);
}
