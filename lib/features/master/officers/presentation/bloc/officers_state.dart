import 'package:kmp_pengurus_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/region_model.dart';
import 'package:kmp_pengurus_app/features/master/officers/data/models/officers_model.dart';

abstract class OfficersState {
  List<Object> get props => [];
}

class OfficersInitial extends OfficersState {}

class OfficersLoading extends OfficersState {}

class OfficersLoaded extends OfficersState {
  OfficersLoaded({
    this.data,
    this.user
  });

  List<Officers>? data;
  UserModel? user;

  @override
  List<Object> get props => [data!, user!];
}

class OfficersCategoryLoaded extends OfficersState {}

class AddOfficersLoaded extends OfficersState {
  AddOfficersLoaded(
      {this.isFromCacheFirst = false,
      this.listVillage,
      this.listRwRt,
      this.listRegion,
      this.listJob});

  bool isFromCacheFirst;
  List<Village>? listVillage;
  List<VillageRwRt>? listRwRt;
  List<RegionModel>? listRegion;
  List<Position>? listJob;

  @override
  List<Object> get props =>
      [isFromCacheFirst, listVillage!, listRwRt!, listRegion!, listJob!];
}

class EditOfficersLoaded extends OfficersState {
  EditOfficersLoaded(
      {this.isFromCacheFirst = false,
      this.listVillage,
      this.listRwRt,
      this.listRegion,
      this.listJob});

  bool isFromCacheFirst;
  List<Village>? listVillage;
  List<VillageRwRt>? listRwRt;
  List<RegionModel>? listRegion;
  List<Position>? listJob;

  @override
  List<Object> get props =>
      [isFromCacheFirst, listVillage!, listRwRt!, listRegion!, listJob!];
}

class EditOfficersSuccess extends OfficersState {
  final bool isSuccess;

  EditOfficersSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class DeleteOfficersSuccess extends OfficersState {
  final bool isSuccess;

  DeleteOfficersSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class OfficersSuccess extends OfficersState {
  final bool isSuccess;

  OfficersSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class OfficersFailure extends OfficersState {
  OfficersFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SubscriptionsFailure { error: $error }';
}
