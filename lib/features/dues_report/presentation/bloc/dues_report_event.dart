import 'package:equatable/equatable.dart';

abstract class FinancialStatementEvent extends Equatable {
  const FinancialStatementEvent();

  @override
  List<Object> get props => [];
}

class LoadCashBook extends FinancialStatementEvent {}


class GetCashBookFinancialEvent extends FinancialStatementEvent {
  final int? year;
  final int? month;

  const GetCashBookFinancialEvent({required this.year, required this.month});

}

class GetPdfReportEvent extends FinancialStatementEvent {
  final int? year;
  final int? month;
  final String? type;

  const GetPdfReportEvent({required this.year, required this.month, required this.type});

}

