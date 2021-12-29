import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/models/cash_book_model.dart';
import 'package:kmp_pengurus_app/features/master/category/data/models/category_model.dart';

abstract class CashBookState {
  List<Object> get props => [];
}

class CashBookInitial extends CashBookState {}

class CashBookLoading extends CashBookState {}

class AddCashBookLoading extends CashBookState {}

class CashBookDataLoaded extends CashBookState {
  CashBookDataLoaded({this.data});

  CashBookModel? data;

  @override
  List<Object> get props => [data!];
}

class AddCashBookLoaded extends CashBookState {
  AddCashBookLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  CategoryModel? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}

class CashBookSuccess extends CashBookState {
  final bool isSuccess;

  CashBookSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class CashBookFailure extends CashBookState {
  CashBookFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'CashBook Failure { error: $error }';
}
