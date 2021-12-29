import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/master/houses/data/models/house_model.dart';

abstract class HousesState {
  List<Object> get props => [];
}

class HousesInitial extends HousesState {}

class HousesLoading extends HousesState {}

class HousesLoaded extends HousesState {
  HousesLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  HousesModel? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}

class AddHousesLoaded extends HousesState {
  AddHousesLoaded({this.data, this.listVillage, this.listRwRt});

  List<Base>? data;
  List<Village>? listVillage;
  List<VillageRwRt>? listRwRt;

  @override
  List<Object> get props => [data!, listVillage!, listRwRt!];
}

class EditHousesLoaded extends HousesState {
  EditHousesLoaded({this.data, this.listVillage, this.listRwRt});

  List<Base>? data;
  List<Village>? listVillage;
  List<VillageRwRt>? listRwRt;

  @override
  List<Object> get props => [data!, listVillage!, listRwRt!];
}

class HousesSuccess extends HousesState {
  final bool isSuccess;

  HousesSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class DeleteHousesSuccess extends HousesState {
  final bool isSuccess;

  DeleteHousesSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class HousesFailure extends HousesState {
  HousesFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'HousesFailure { error: $error }';
}
