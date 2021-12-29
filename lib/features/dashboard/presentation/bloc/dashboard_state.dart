import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_chart_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/guest_book_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/visitor_model.dart';
import 'package:kmp_pengurus_app/features/profile/data/models/profile_model.dart';

abstract class DashboardState {
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardChartLoading extends DashboardState {}
class UserSessionLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  DashboardLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  DashboardModel? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}


class ChartDataLoaded extends DashboardState {
  ChartDataLoaded({this.chartData});

  DashboardChartModel? chartData;

  @override
  List<Object> get props => [chartData!];
}

class UserSessionLoaded extends DashboardState {
  UserSessionLoaded({this.userSession});

  ProfileModel? userSession;

  @override
  List<Object> get props => [userSession!];
}

class DashboardFailure extends DashboardState {
  DashboardFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'DashboardFailure { error: $error }';
}


class GuestBookLoading extends DashboardState {}

class AllGuestBookLoading extends DashboardState {}

class GuestBookLoaded extends DashboardState{
  GuestBookLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  GuestBookModel? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}

class AllGuestBookLoaded extends DashboardState{
  AllGuestBookLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  VisitorModel? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}