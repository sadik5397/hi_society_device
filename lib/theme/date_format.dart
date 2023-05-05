import 'package:intl/intl.dart';

String primaryDateTime(String dateTime) => DateFormat('dd MMM yyyy | hh:mm a').format(DateTime.parse(dateTime));
String primaryDate(String dateTime) => DateFormat('dd MMM yyyy').format(DateTime.parse(dateTime));
String apiDate(String dateTime) => DateFormat('yyyy-MM-dd').format(DateTime.parse(dateTime));
String primaryTime(String dateTime) => DateFormat('hh:mm a').format(DateTime.parse(dateTime));

//GMT+6
// String primaryDateTime(String dateTime) => DateFormat('dd MMM yyyy | hh:mm a').format(DateTime.parse(dateTime).add(const Duration(hours: 6)));
// String primaryDate(String dateTime) => DateFormat('dd MMM yyyy').format(DateTime.parse(dateTime).add(const Duration(hours: 6)));
// String apiDate(String dateTime) => DateFormat('yyyy-MM-dd').format(DateTime.parse(dateTime).add(const Duration(hours: 6)));
// String primaryTime(String dateTime) => DateFormat('hh:mm a').format(DateTime.parse(dateTime).add(const Duration(hours: 6)));
