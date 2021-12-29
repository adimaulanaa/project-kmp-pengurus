import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboard extends DashboardEvent {}

class LoadDashboardChart extends DashboardEvent {}

class GetUserSessionEvent extends DashboardEvent {}

class LoadGuestBook extends DashboardEvent {}

class LoadAllGuestBook extends DashboardEvent {}

class GetChartDataEvent extends DashboardEvent {
  final int? year;
  final int? month;

  const GetChartDataEvent({required this.year, required this.month});

}


