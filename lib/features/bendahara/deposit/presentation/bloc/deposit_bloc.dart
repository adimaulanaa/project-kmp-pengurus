import 'dart:async';
import 'package:kmp_pengurus_app/features/bendahara/deposit/domain/usecases/deposit_usecase.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/presentation/bloc/deposit_event.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/presentation/bloc/deposit_state.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  DepositBloc({
    required DepositUseCase deposit,
    required HiveDbServices dbServices,
    required PostDepositUseCase addDeposit,
  })  : _deposit = deposit,
        _addDeposit = addDeposit,
        super(DepositInitial());

  final DepositUseCase _deposit;
  final PostDepositUseCase _addDeposit;

  @override
  Stream<DepositState> mapEventToState(
    DepositEvent event,
  ) async* {
    if (event is LoadDeposit) {
      yield DepositLoading();

      final failureOrSuccess = await _deposit(NoParams());
      yield failureOrSuccess.fold(
        (failure) => DepositFailure(error: mapFailureToMessage(failure)),
        (success) => DepositLoaded(data: success),
      );
    }
    

    if (event is AddDepositEvent) {
      final failureOrSuccess = await _addDeposit(event.deposit);
      yield failureOrSuccess.fold(
          (failure) => DepositFailure(error: mapFailureToMessage(failure)),
          (loaded) => DepositSuccess(isSuccess: loaded));
    }
  }
}
