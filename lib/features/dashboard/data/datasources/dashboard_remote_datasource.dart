import 'dart:io';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/data.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_chart_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/guest_book_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/visitor_model.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/framework/managers/http_manager.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardModel> getDashboard();
  Future<DashboardChartModel> getDashboardChart(CashBookData dataChart);
  Future<GuestBookModel> getGuestBook();
  Future<VisitorModel> getAllGuestBook();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<DashboardModel> getDashboard() =>
      _getDasboardFromUrl('/home?with_region=false&with_data=true');

  Future<DashboardModel> _getDasboardFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.get(
      url: url,
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );

    if (response != null && response.statusCode == 201) {
      return DashboardModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<DashboardChartModel> getDashboardChart(CashBookData dataChart) =>
      _getDashboardChartFromUrl(
          '/dashboard/' +
              dataChart.month.toString() +
              '/' +
              dataChart.year.toString(),
          dataChart);

  Future<DashboardChartModel> _getDashboardChartFromUrl(
      String url, CashBookData data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);
    final response = await httpManager.get(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    });

    if (response != null && response.statusCode == 201) {
      return DashboardChartModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<GuestBookModel> getGuestBook() =>
      _getGuestBookFromUrl('/visitors/today');

  Future<GuestBookModel> _getGuestBookFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "date": DateTime.now().toString()
    });

    if (response != null && response.statusCode == 201) {
      return GuestBookModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<VisitorModel> getAllGuestBook() =>
      _getAllGuestBookFromUrl('/visitors/pagination');

  Future<VisitorModel> _getAllGuestBookFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "limit": -1,
      "page": 0,
      "sort": "-accepted_at",
    });

    if (response != null && response.statusCode == 201) {
      return VisitorModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
