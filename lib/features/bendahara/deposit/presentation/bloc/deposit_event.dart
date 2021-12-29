import 'package:equatable/equatable.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/domain/entities/post_deposit.dart';

abstract class DepositEvent extends Equatable {
  const DepositEvent();

  @override
  List<Object> get props => [];
}

class LoadDeposit extends DepositEvent {}

class AddDepositEvent extends DepositEvent {
  final PostDeposit deposit;

  const AddDepositEvent({
    required this.deposit,
  });
}
