import 'dart:io';

import 'package:kmp_pengurus_app/features/master/houses/data/models/house_model.dart';
import 'package:kmp_pengurus_app/features/master/houses/domain/entities/post_houses.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/framework/managers/http_manager.dart';

abstract class HouseRemoteDataSource {
  Future<HousesModel> getHouse();
  Future<bool> postHouse(PostHouses data);
  Future<bool> editHouse(PostHouses data);
  Future<bool> deleteHouse(String idHouse);
}

class HouseRemoteDataSourceImpl implements HouseRemoteDataSource {
  HouseRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<HousesModel> getHouse() => _getHousesFromUrl('/houses/pagination');

  Future<HousesModel> _getHousesFromUrl(String url) async {
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

  @override
  Future<bool> postHouse(PostHouses data) => _postHouseFromUrl('/houses', data);

  Future<bool> _postHouseFromUrl(String url, PostHouses data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "rt_place": data.rtPlace,
      "street": data.street,
      "house_block": data.houseBlock,
      "house_number": data.houseNumber,
      "is_vacant": data.isVacant,
      "citizen_id_card": data.citizenIdCard,
      "citizen_name": data.citizenName,
      "citizen_gender": data.citizenGender,
      "citizen_phone": data.citizenPhone,
      "is_permanent_citizen": data.isPermanentCitizen,
      "subscriptions": data.subscriptions,
      "is_free": data.isFree
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> editHouse(PostHouses data) =>
      _editHouseFromUrl('/houses/' + data.id!, data);

  Future<bool> _editHouseFromUrl(String url, PostHouses data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);


    final response = await httpManager.put(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "rt_place": data.rtPlace,
      "street": data.street,
      "house_block": data.houseBlock,
      "house_number": data.houseNumber,
      "is_vacant": data.isVacant,
      "citizen_id_card": data.citizenIdCard,
      "citizen_name": data.citizenName,
      "citizen_gender": data.citizenGender,
      "citizen_phone": data.citizenPhone,
      "is_permanent_citizen": data.isPermanentCitizen,
      "subscriptions": data.subscriptions,
      "is_free": data.isFree,
      "is_active": true
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> deleteHouse(String idHouse) =>
      _deleteHouse('/houses/' + idHouse);

  Future<bool> _deleteHouse(
    String url,
  ) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);


    final response = await httpManager.delete(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }
}
