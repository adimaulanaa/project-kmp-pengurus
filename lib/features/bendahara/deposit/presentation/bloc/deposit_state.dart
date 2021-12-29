import 'package:kmp_pengurus_app/features/bendahara/deposit/data/models/deposit_model.dart';

abstract class DepositState {
  List<Object> get props => [];
}

class DepositInitial extends DepositState {}

class DepositLoading extends DepositState {}

class DepositLoaded extends DepositState {
  DepositLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  DepositModel? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}

class AddDepositLoaded extends DepositState {
  AddDepositLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  List<Option>? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}

class DepositSuccess extends DepositState {
  final bool isSuccess;

  DepositSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class DepositFailure extends DepositState {
  DepositFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Deposit Failure { error: $error }';
}
