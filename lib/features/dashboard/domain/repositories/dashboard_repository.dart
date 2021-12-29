import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/data.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_chart_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/guest_book_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/visitor_model.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardModel>> dashboard();
  Future<Either<Failure, DashboardModel>> dashboardFromCache();
  Future<Either<Failure, DashboardChartModel>> dashboardChartFromCache();
  Future<Either<Failure, DashboardChartModel>> dashboardChart(CashBookData dataChart);
  Future<Either<Failure, GuestBookModel>> guestBook();
  Future<Either<Failure, VisitorModel>> allGuestBook();
}
