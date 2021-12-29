import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/data.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_chart_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/guest_book_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/visitor_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';

class DashboardUseCase implements UseCase<DashboardModel, NoParams> {
  DashboardUseCase(this.repository);

  final DashboardRepository repository;

  @override
  Future<Either<Failure, DashboardModel>> call(NoParams params) =>
      repository.dashboard();
}

class DashboardFromCacheUseCase implements UseCase<DashboardModel, NoParams> {
  DashboardFromCacheUseCase(this.repository);

  final DashboardRepository repository;

  @override
  Future<Either<Failure, DashboardModel>> call(NoParams params) =>
      repository.dashboardFromCache();
}

class DashboardChartUseCase implements UseCase<DashboardChartModel, CashBookData> {
  DashboardChartUseCase(this.repository);

  final DashboardRepository repository;

  @override
  Future<Either<Failure, DashboardChartModel>> call(CashBookData params) =>
      repository.dashboardChart(params);
}

class DashboardChartFromCache
    implements UseCase<DashboardChartModel, NoParams> {
  DashboardChartFromCache(this.repository);

  final DashboardRepository repository;

  @override
  Future<Either<Failure, DashboardChartModel>> call(NoParams params) =>
      repository.dashboardChartFromCache();
}


class GuestBookUseCase implements UseCase<GuestBookModel, NoParams> {
  GuestBookUseCase(this.repository);

  final DashboardRepository repository;

  @override
  Future<Either<Failure, GuestBookModel>> call(NoParams params) =>
      repository.guestBook();
}

class AllGuestBookUseCase implements UseCase<VisitorModel, NoParams> {
  AllGuestBookUseCase(this.repository);

  final DashboardRepository repository;

  @override
  Future<Either<Failure, VisitorModel>> call(NoParams params) =>
      repository.allGuestBook();
}