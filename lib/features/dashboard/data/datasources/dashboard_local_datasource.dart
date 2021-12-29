import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_chart_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/guest_book_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/visitor_model.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DashboardLocalDataSource {
  Future<void> cacheDashboard(DashboardModel dashboardToCache); 
  Future<DashboardModel> getLastCacheDashboard();
  Future<void> cacheDashboardChart(DashboardChartModel dashboardChartToCache);
  Future<DashboardChartModel> getLastCacheDashboardChart();
  Future<void> cacheGustBook(GuestBookModel guestBookToCache);
  Future<GuestBookModel> getLastCacheGuestBook();
  Future<void> cacheAllGuestBook(VisitorModel guestBookToCache);
  Future<VisitorModel> getLastCacheAllGuestBook();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  DashboardLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheDashboard(DashboardModel dashboardToCache) async {
    await _cacheDashboardLocalStorage(dashboardToCache);
  }

  @override
  Future<DashboardModel> getLastCacheDashboard() async {
    final data = await dbServices.getData(HiveDbServices.boxLoggedInUser);
    DashboardModel result = new DashboardModel();
    if (data != null) {
      result = dashboardModelFromJson(data);
    }
    return result;
  }

  Future<void> _cacheDashboardLocalStorage(
      DashboardModel dashboardToCache) async {
    String data = dashboardModelToJson(dashboardToCache);
    await dbServices.addData(HiveDbServices.boxDashboard, data);
  }

  @override
  Future<void> cacheDashboardChart(
      DashboardChartModel dashboardChartToCache) async {
    await _cacheDashboardChartLocalStorage(dashboardChartToCache);
  }

  @override
  Future<DashboardChartModel> getLastCacheDashboardChart() async {
    final data = await dbServices.getData(HiveDbServices.boxLoggedInUser);
    DashboardChartModel result = new DashboardChartModel();
    if (data != null) {
      result = dashboardChartModelFromJson(data);
    }
    return result;
  }

  Future<void> _cacheDashboardChartLocalStorage(
      DashboardChartModel cashBookToCache) async {
    String data = dashboardChartModelToJson(cashBookToCache);
    await dbServices.addData(HiveDbServices.boxLoggedInUser, data);
  }

  
  @override
  Future<void> cacheGustBook(GuestBookModel guestBookToCache) async {
    await _cacheGuestBookLocalStorage(guestBookToCache);
  }

  @override
  Future<void> cacheAllGuestBook(VisitorModel guestBookToCache) async {
    await _cacheAllGuestBookLocalStorage(guestBookToCache);
  }

  @override
  Future<GuestBookModel> getLastCacheGuestBook() async {
    final data = await dbServices.getData(HiveDbServices.boxGuest);
    GuestBookModel result = new GuestBookModel();
    if (data != null) {
      result = guestBookModelFromJson(data);
    }
    return result;
  }

  @override
  Future<VisitorModel> getLastCacheAllGuestBook() async {
    final data = await dbServices.getData(HiveDbServices.boxGuest);
    VisitorModel result = new VisitorModel();
    if (data != null) {
      result = visitorModelFromJson(data);
    }
    return result;
  }

   Future<void> _cacheGuestBookLocalStorage(
      GuestBookModel guestBookToCache) async {
    String data = guestBookModelToJson(guestBookToCache);
    await dbServices.addData(HiveDbServices.boxGuest, data);
  }
   Future<void> _cacheAllGuestBookLocalStorage(
      VisitorModel allGuestBookToCache) async {
    String data = visitorModelToJson(allGuestBookToCache);
    await dbServices.addData(HiveDbServices.boxGuest, data);
  }
}
