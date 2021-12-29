import 'package:kmp_pengurus_app/features/dues/data/models/dues_model.dart';
import 'package:kmp_pengurus_app/features/master/houses/data/models/house_model.dart';

abstract class DuesState {
  List<Object> get props => [];
}

class DuesInitial extends DuesState {}

class HouseListLoading extends DuesState {}

class HouseListLoaded extends DuesState {
  HouseListLoaded({
    this.isFromCacheFirst = false,
    this.houseData,
  });

  bool isFromCacheFirst;
  HousesModel? houseData;

  @override
  List<Object> get props => [isFromCacheFirst, houseData!];
}

class MonthYearLoaded extends DuesState {
  MonthYearLoaded({this.data});

  CitizenSubscriptionsModel? data;

  @override
  List<Object> get props => [data!];
}

class DuesSuccess extends DuesState {
  final bool isSuccess;

  DuesSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class DuesFailure extends DuesState {
  DuesFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Dues Failure { error: $error }';
}
