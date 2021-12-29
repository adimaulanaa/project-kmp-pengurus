import 'dart:async';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/data.dart';
import 'package:kmp_pengurus_app/features/dashboard/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/profile/domain/usecases/profile_usecase.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:kmp_pengurus_app/features/dashboard/domain/usecases/dashboard_usecase.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required DashboardUseCase dashboard,
    required DashboardChartUseCase dashboardChart,
    required ProfileUseCase session,
    required GuestBookUseCase guestBook,
    required AllGuestBookUseCase allGuestBook,
    required DashboardFromCacheUseCase dashboardFromCache,
  })  : _dashboard = dashboard,
  _guestBook = guestBook,
  _allGuestBook = allGuestBook,
  _dashboardChart = dashboardChart,
   _session = session,
        _dashboardFromCache = dashboardFromCache,
        super(DashboardInitial());

  final DashboardUseCase _dashboard;
  final DashboardChartUseCase _dashboardChart;
  final GuestBookUseCase _guestBook;
  final AllGuestBookUseCase _allGuestBook;
  final ProfileUseCase _session;

  final DashboardFromCacheUseCase _dashboardFromCache;

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if (event is LoadDashboard) {
      yield DashboardLoading();

      final failureOrSuccessFromCache = await _dashboardFromCache(NoParams());
      yield failureOrSuccessFromCache.fold(
        (failure) => DashboardFailure(error: mapFailureToMessage(failure)),
        (success) => DashboardLoaded(
          data: success,
        ),
      );

      final failureOrSuccess = await _dashboard(NoParams());
      yield failureOrSuccess.fold(
        (failure) => DashboardFailure(error: mapFailureToMessage(failure)),
        (success) => DashboardLoaded(data: success),
      );
    } else if (event is GetUserSessionEvent) {
      yield UserSessionLoading();

      final failureOrSuccess = await _session(NoParams());
      yield failureOrSuccess.fold(
        (failure) => DashboardFailure(error: mapFailureToMessage(failure)),
        (success) => UserSessionLoaded(userSession: success),
      );
    }
     else if (event is GetChartDataEvent) {
      yield DashboardChartLoading();
      final failureOrSuccess =
          await _dashboardChart(CashBookData(year: event.year!, month: event.month!));
      yield failureOrSuccess.fold(
        (failure) => DashboardFailure(error: mapFailureToMessage(failure)),
        (success) => ChartDataLoaded(chartData: success),
      );
    } else if (event is LoadGuestBook) {
      yield GuestBookLoading();
      
      final failureOrSuccess = await _guestBook(NoParams());
      yield failureOrSuccess.fold(
        (failure) => DashboardFailure(error: mapFailureToMessage(failure)),
        (success) => GuestBookLoaded(data: success),
      );
    } else if (event is LoadAllGuestBook) {
      yield AllGuestBookLoading();
      
      final failureOrSuccess = await _allGuestBook(NoParams());
      yield failureOrSuccess.fold(
        (failure) => DashboardFailure(error: mapFailureToMessage(failure)),
        (success) => AllGuestBookLoaded(data: success),
      );
    }
  }
}
