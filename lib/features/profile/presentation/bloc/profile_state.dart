import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/region_model.dart';
import 'package:kmp_pengurus_app/features/profile/data/models/profile_model.dart';

abstract class ProfileState {
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  ProfileLoaded({
    this.data,
    this.profile
  });

  Caretaker? data;
  ProfileModel? profile;

  @override
  List<Object> get props => [data!, profile!];
}

class OfficersCategoryLoaded extends ProfileState {}

class EditProfileLoaded extends ProfileState {
  EditProfileLoaded({
    this.isFromCacheFirst = false,
    this.listVillage,
    this.listRegion,
  });

  bool isFromCacheFirst;
  List<Village>? listVillage;
  List<RegionModel>? listRegion;

  @override
  List<Object> get props => [isFromCacheFirst, listVillage!, listRegion!];
}

class EditProfileSuccess extends ProfileState {
  final bool isSuccess;

  EditProfileSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class ChangePasswordSuccess extends ProfileState {
  final bool isSuccess;

  ChangePasswordSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class ProfileSuccess extends ProfileState {
  final bool isSuccess;

  ProfileSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class ProfileFailure extends ProfileState {
  ProfileFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Profile Failure { error: $error }';
}
