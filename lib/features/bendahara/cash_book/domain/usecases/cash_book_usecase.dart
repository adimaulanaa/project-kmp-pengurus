import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/models/cash_book_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/data.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/post_cash_book.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/repositories/cash_book_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';

class CashBookUseCase implements UseCase<CashBookModel, CashBookData> {
  CashBookUseCase(this.repository);

  final CashBookRepository repository;

  @override
  Future<Either<Failure, CashBookModel>> call(CashBookData params) =>
      repository.cashBook(params);
}

class CashBookFromCacheUseCase
    implements UseCase<CashBookModel, NoParams> {
  CashBookFromCacheUseCase(this.repository);

  final CashBookRepository repository;

  @override
  Future<Either<Failure, CashBookModel>> call(NoParams params) =>
      repository.cashBookFromCache();
}

class PostCashBookUseCase implements UseCase<bool, PostCashBook> {

  PostCashBookUseCase(this.repository);

  final CashBookRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostCashBook params) =>
      repository.postCashBook(params);
}

