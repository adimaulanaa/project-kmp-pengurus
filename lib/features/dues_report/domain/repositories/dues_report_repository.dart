import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/models/cash_book_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/data.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';

abstract class FinancialStatementRepository {
  
  Future<Either<Failure, CashBookModel>> cashBook(CashBookData dataCashBook);
  Future<Either<Failure, String>> getPdf(CashBookData getPdf);
  Future<Either<Failure, CashBookModel>> cashBookFromCache();
}
