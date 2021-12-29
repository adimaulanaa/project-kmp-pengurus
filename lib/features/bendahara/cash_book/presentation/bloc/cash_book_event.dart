import 'package:equatable/equatable.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/post_cash_book.dart';

abstract class CashBookEvent extends Equatable {
  const CashBookEvent();

  @override
  List<Object> get props => [];
}

class LoadCashBook extends CashBookEvent {}

class AddLoadCashBook extends CashBookEvent {

}

class GetCashBookDataEvent extends CashBookEvent {
  final int? year;
  final int? month;

  const GetCashBookDataEvent({required this.year, required this.month});

}

class AddCashBookEvent extends CashBookEvent {
  final PostCashBook cashBook;

  const AddCashBookEvent({
    required this.cashBook,
  });
}
