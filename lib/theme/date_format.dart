import 'package:intl/intl.dart';

String primaryDateTime(String dateTime) => DateFormat('dd MMM yyyy | hh:mm a').format(DateTime.parse(dateTime));
String primaryDate(String dateTime) => DateFormat('dd MMM yyyy').format(DateTime.parse(dateTime));
String primaryTime(String dateTime) => DateFormat('hh:mm a').format(DateTime.parse(dateTime));
