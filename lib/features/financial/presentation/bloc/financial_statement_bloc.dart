import 'dart:async';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/data.dart';
import 'package:kmp_pengurus_app/features/financial/domain/usecases/financial_statement_usecase.dart';
import 'package:kmp_pengurus_app/features/financial/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';

class FinancialStatementBloc
    extends Bloc<FinancialStatementEvent, FinancialStatementState> {
  FinancialStatementBloc(
      {required FinancialStatementUseCase cashBookFinancial,
      required PdfReportUseCase pdfReport,
      required FinancialStatementFromCacheUseCase cashBookFinancialFromCache})
      : _cashBookFinancial = cashBookFinancial,
        _pdfReport = pdfReport,
        _cashBookFinancialFromCache = cashBookFinancialFromCache,
        super(FinancialStatementInitial());

  final FinancialStatementUseCase _cashBookFinancial;
  final PdfReportUseCase _pdfReport;
  final FinancialStatementFromCacheUseCase _cashBookFinancialFromCache;

  @override
  Stream<FinancialStatementState> mapEventToState(
    FinancialStatementEvent event,
  ) async* {
    if (event is GetCashBookFinancialEvent) {
      yield CashBookFinancialLoading();
      final failureOrSuccessFromCache =
          await _cashBookFinancialFromCache(NoParams());
      yield failureOrSuccessFromCache.fold(
        (failure) =>
            FinancialStatementFailure(error: mapFailureToMessage(failure)),
        (success) => CashBookFinancialLoaded(
          data: success,
        ),
      );

      final failureOrSuccess = await _cashBookFinancial(
          CashBookData(year: event.year!, month: event.month!));
      yield failureOrSuccess.fold(
        (failure) =>
            FinancialStatementFailure(error: mapFailureToMessage(failure)),
        (success) => CashBookFinancialLoaded(data: success),
      );
    } else if (event is GetPdfReportEvent) {
      yield GetPdfReportLoading();

      final failureOrSuccess = await _pdfReport(CashBookData(
          year: event.year!, month: event.month!, type: event.type));

      if (failureOrSuccess.isRight()) {
        final pdfResult = failureOrSuccess.toOption().toNullable()!;

        yield GetPdfReportLoaded(data: pdfResult);
      } else {
        yield failureOrSuccess.fold(
          (failure) =>
              FinancialStatementFailure(error: mapFailureToMessage(failure)),
          (success) => GetPdfReportLoaded(data: ''),
        );
      }
    }
  }
}
