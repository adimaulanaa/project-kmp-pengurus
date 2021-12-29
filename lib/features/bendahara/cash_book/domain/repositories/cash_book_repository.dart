import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/models/cash_book_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/data.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/post_cash_book.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';

abstract class CashBookRepository {
  
  Future<Either<Failure, bool>> postCashBook(PostCashBook cashBook);
  Future<Either<Failure, CashBookModel>> cashBook(CashBookData dataCashBook);
  Future<Either<Failure, CashBookModel>> cashBookFromCache();
}
