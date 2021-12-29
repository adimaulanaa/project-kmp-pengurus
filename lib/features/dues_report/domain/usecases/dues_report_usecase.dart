import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/models/cash_book_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/data.dart';
import 'package:kmp_pengurus_app/features/financial/domain/repositories/financial_statement_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';

class FinancialStatementUseCase implements UseCase<CashBookModel, CashBookData> {
  FinancialStatementUseCase(this.repository);

  final FinancialStatementRepository repository;

  @override
  Future<Either<Failure, CashBookModel>> call(CashBookData params) =>
      repository.cashBook(params);
}

class PdfReportUseCase implements UseCase<String, CashBookData> {
  PdfReportUseCase(this.repository);

  final FinancialStatementRepository repository;

  @override
  Future<Either<Failure, String>> call(CashBookData params) =>
      repository.getPdf(params);
}

class FinancialStatementFromCacheUseCase
    implements UseCase<CashBookModel, NoParams> {
  FinancialStatementFromCacheUseCase(this.repository);

  final FinancialStatementRepository repository;

  @override
  Future<Either<Failure, CashBookModel>> call(NoParams params) =>
      repository.cashBookFromCache();
}

