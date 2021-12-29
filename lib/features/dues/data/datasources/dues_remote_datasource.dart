import 'dart:io';

import 'package:kmp_pengurus_app/features/dues/data/models/dues_model.dart';
import 'package:kmp_pengurus_app/features/dues/domain/entities/post_dues.dart';
import 'package:kmp_pengurus_app/features/dues/entities/data.dart';
import 'package:kmp_pengurus_app/features/master/houses/data/models/house_model.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/framework/managers/http_manager.dart';

abstract class DuesRemoteDataSource {
  Future<HousesModel> getHouse();
  Future<bool> postDues(PostDues data);
  Future<CitizenSubscriptionsModel> getMonthYear(GetDataHouse data);
}

class DuesRemoteDataSourceImpl implements DuesRemoteDataSource {
  DuesRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<bool> postDues(PostDues data) =>
      _postDuesFromUrl('/citizen_subscriptions', data);

  Future<bool> _postDuesFromUrl(String url, PostDues data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);
    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "house": data.house,
      "month_number": data.monthNumber,
      "year": data.year,
      "subscriptions": data.subscriptions
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CitizenSubscriptionsModel> getMonthYear(GetDataHouse data) =>
      _postDataHouseFromUrl('/citizen_subscriptions', data);

  Future<CitizenSubscriptionsModel> _postDataHouseFromUrl(
      String url, GetDataHouse data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);
    final response = await httpManager.get(
      url: url,
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
      query: {"house": data.idHouse, "year": data.year},
    );

    if (response != null && response.statusCode == 201) {
      return CitizenSubscriptionsModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<HousesModel> getHouse() => _getListHousesFromUrl('/houses/pagination');

  Future<HousesModel> _getListHousesFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);
    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "limit": -1,
      "page": 0,
      "sort": "house_block",
    });

    if (response != null && response.statusCode == 201) {
      return HousesModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
