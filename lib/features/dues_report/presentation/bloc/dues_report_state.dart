import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/models/cash_book_model.dart';

abstract class FinancialStatementState {
  List<Object> get props => [];
}

class FinancialStatementInitial extends FinancialStatementState {}

class CashBookFinancialLoading extends FinancialStatementState {}

class CashBookFinancialLoaded extends FinancialStatementState {
  CashBookFinancialLoaded({this.data});

  CashBookModel? data;

  @override
  List<Object> get props => [data!];
}

class GetPdfReportLoading extends FinancialStatementState {}

class GetPdfReportLoaded extends FinancialStatementState {
  GetPdfReportLoaded({this.data});

  String? data;

  @override
  List<Object> get props => [data!];
}

class FinancialStatementSuccess extends FinancialStatementState {
  final bool isSuccess;

  FinancialStatementSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class FinancialStatementFailure extends FinancialStatementState {
  FinancialStatementFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'CashBook Failure { error: $error }';
}
