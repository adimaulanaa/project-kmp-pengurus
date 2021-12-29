import 'dart:async';
import 'package:kmp_pengurus_app/features/master/caretaker/domain/usecases/caretaker_usecase.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';

class CaretakerBloc extends Bloc<CaretakerEvent, CaretakerState> {
  CaretakerBloc({
    required CaretakerUseCase caretaker,
    required CaretakerFromCacheUseCase caretakerFromCache,
    required HiveDbServices dbServices,
    required PostCaretakerUseCase addCaretaker,
    required EditCaretakerUseCase editCaretaker,
  })  : _caretaker = caretaker,
        _caretakerFromCache = caretakerFromCache,
        _addCaretaker = addCaretaker,
        _editCaretaker = editCaretaker,
        super(CaretakerInitial());

  final CaretakerUseCase _caretaker;
  final PostCaretakerUseCase _addCaretaker;
  final EditCaretakerUseCase _editCaretaker;
  final CaretakerFromCacheUseCase _caretakerFromCache;

  @override
  Stream<CaretakerState> mapEventToState(
    CaretakerEvent event,
  ) async* {
    if (event is LoadCaretaker) {
      yield CaretakerLoading();
      final failureOrSuccessFromCache =
          await _caretakerFromCache(NoParams());
      yield failureOrSuccessFromCache.fold(
        (failure) => CaretakerFailure(error: mapFailureToMessage(failure)),
        (success) => CaretakerLoaded(
          data: success,
        ),
      );

      final failureOrSuccess = await _caretaker(NoParams());
      yield failureOrSuccess.fold(
        (failure) => CaretakerFailure(error: mapFailureToMessage(failure)),
        (success) => CaretakerLoaded(data: success),
      );
    }
    if (event is AddLoadCaretaker) {
      
      yield AddCaretakerLoaded();
    }

    if (event is EditLoadCaretaker) {
      
      yield EditCaretakerLoaded();
    }

    if (event is AddCaretakerEvent) {
      final failureOrSuccess = await _addCaretaker(event.caretaker);
      yield failureOrSuccess.fold(
          (failure) => CaretakerFailure(error: mapFailureToMessage(failure)),
          (loaded) => CaretakerSuccess(isSuccess: loaded));
    }

    if (event is EditCaretakerEvent) {
      final failureOrSuccess = await _editCaretaker(event.caretakerEdit);
      yield failureOrSuccess.fold(
          (failure) => CaretakerFailure(error: mapFailureToMessage(failure)),
          (loaded) => CaretakerSuccess(isSuccess: loaded));
    }
  }
}
