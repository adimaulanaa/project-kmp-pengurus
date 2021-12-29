import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class CashBookData extends Equatable {
  CashBookData({
    required this.year,
    required this.month,
    this.type
  });

  final int month;
  final int year;
  final String? type;

  List<Object> get props => [month, year, type!];
}
