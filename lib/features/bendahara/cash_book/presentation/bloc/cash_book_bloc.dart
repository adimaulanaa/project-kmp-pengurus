import 'dart:async';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/data.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/usecases/cash_book_usecase.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/master/category/domain/usecases/category_usecase.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';

class CashBookBloc extends Bloc<CashBookEvent, CashBookState> {
  CashBookBloc({
    required CashBookUseCase cashBook,
    required CashBookFromCacheUseCase cashBookFromCache,
    required PostCashBookUseCase addCashBook,
      required CategoryFromCacheUseCase categoryFromCache,
  required CategoryUseCase category
 

  })  : _cashBook = cashBook,
        _cashBookFromCache = cashBookFromCache,
        _addCashBook = addCashBook,
        _categoryFromCache = categoryFromCache,
        _category = category,
        super(CashBookInitial());

  final CashBookUseCase _cashBook;
  final PostCashBookUseCase _addCashBook;
  final CashBookFromCacheUseCase _cashBookFromCache;
  final CategoryFromCacheUseCase _categoryFromCache;
  final CategoryUseCase _category;

  @override
  Stream<CashBookState> mapEventToState(
    CashBookEvent event,
  ) async* {
    if (event is GetCashBookDataEvent) {
      yield CashBookLoading();
      final failureOrSuccessFromCache =
          await _cashBookFromCache(NoParams());
      yield failureOrSuccessFromCache.fold(
        (failure) => CashBookFailure(error: mapFailureToMessage(failure)),
        (success) => CashBookDataLoaded(
          data: success,
        ),
      );

      final failureOrSuccess = await _cashBook(CashBookData(year: event.year!, month: event.month!));
      yield failureOrSuccess.fold(
        (failure) => CashBookFailure(error: mapFailureToMessage(failure)),
        (success) => CashBookDataLoaded(data: success),
      );
    }

    if (event is AddLoadCashBook) {
      yield AddCashBookLoading();
      final failureOrSuccessFromCache =
          await _categoryFromCache(NoParams());
      yield failureOrSuccessFromCache.fold(
        (failure) => CashBookFailure(error: mapFailureToMessage(failure)),
        (success) => AddCashBookLoaded(
          data: success,
        ),
      );

      final failureOrSuccess = await _category(NoParams());
      yield failureOrSuccess.fold(
        (failure) => CashBookFailure(error: mapFailureToMessage(failure)),
        (success) => AddCashBookLoaded(data: success),
      );
    }

    if (event is AddCashBookEvent) {
      final failureOrSuccess = await _addCashBook(event.cashBook);
      yield failureOrSuccess.fold(
          (failure) => CashBookFailure(
              error: "Gagal Menambahkan Data"),
          (loaded) => CashBookSuccess(isSuccess: loaded));
    }
  }
}
