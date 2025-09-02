import 'package:intl/intl.dart';

final formatPattern = NumberFormat('#,###');

String getPriceFormat(String price){
  return formatPattern.format(double.parse(price)) + 'تومان';
}