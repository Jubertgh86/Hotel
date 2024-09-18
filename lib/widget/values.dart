import 'package:intl/intl.dart';

num intMax = 2147483647;
double constRadius = 10;
double textS = 12;

var dateTimeFormat = DateFormat('dd/MM/yyyy hh:mm:ss');
var dateFormat = DateFormat('dd/MM/yyyy');
var dateVencimiento = DateFormat('dd-MM-yyyy');
NumberFormat formatoMoneda = NumberFormat.currency(
  symbol: 'RD\$',
  decimalDigits: 2, // Elige el símbolo de moneda deseado
);
