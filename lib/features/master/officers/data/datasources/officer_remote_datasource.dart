import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kmp_pengurus_app/features/master/officers/data/models/officers_model.dart';
import 'package:kmp_pengurus_app/features/master/officers/domain/entities/post_officers.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/framework/managers/http_manager.dart';

abstract class OfficersRemoteDataSource {
  Future<OfficersModel> getOfficers();
  Future<bool> postOfficers(PostOfficers data);
  Future<bool> editOfficers(PostOfficers data);
  Future<bool> deleteOfficers(String idSubscription);
}

class OfficersRemoteDataSourceImpl implements OfficersRemoteDataSource {
  OfficersRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<OfficersModel> getOfficers() =>
      _getOfficersFromUrl('/officers/pagination');

  Future<OfficersModel> _getOfficersFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "limit": -1,
      "page": 0,
      "sort": "name",
    });

    if (response != null && response.statusCode == 201) {
      return OfficersModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> postOfficers(PostOfficers data) =>
      _postOfficersFromUrl('/officers', data);

  Future<bool> _postOfficersFromUrl(String url, PostOfficers data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "id_card": data.idCard,
      "name": data.name,
      "gender": data.gender,
      "sub_district": data.subDistrict,
      "street": data.street,
      "rt": data.rt,
      "rw": data.rw,
      "assignments": data.assignments,
      "email": data.email,
      "phone": data.phone,
      "phone_2": data.phone2,
      "position": data.position
    });

    if (response != null && response.statusCode == 201) {
      var id = response.data['_id'];
      if (data.pathKtp!.isNotEmpty) {
        await _postKtpFromUrl('/files/upload', data, id);
      }
      if (data.pathImage!.isNotEmpty) {
        await _postImageFromUrl('/files/upload', data, id);
      }
      return true;
    } else {
      throw ServerException();
    }
  }

  Future<bool> _postKtpFromUrl(String url, PostOfficers data, String id) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final mimeTypes = lookupMimeType(data.pathKtp!)!.split('/');
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(data.pathKtp!,
          contentType: MediaType(mimeTypes[0], mimeTypes[1])),
      "type": "officer",
      "is_compress": true,
      "id": id,
      "index": 1
    });

    final response = await httpManager.post(
      url: url,
      formData: formData,
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
      isUploadImage: true,
    );

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  Future<bool> _postImageFromUrl(
      String url, PostOfficers data, String id) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final mimeTypes = lookupMimeType(data.pathImage!)!.split('/');
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(data.pathImage!,
          contentType: MediaType(mimeTypes[0], mimeTypes[1])),
      "type": "officer",
      "is_compress": true,
      "id": id,
      "index": 2
    });

    final response = await httpManager.post(
      url: url,
      formData: formData,
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
      isUploadImage: true,
    );

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> editOfficers(PostOfficers data) =>
      _editOfficersFromUrl('/officers/' + data.id!, data);

  Future<bool> _editOfficersFromUrl(String url, PostOfficers data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.put(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "id_card": data.idCard,
      "name": data.name,
      "gender": data.gender,
      "sub_district": data.subDistrict,
      "street": data.street,
      "rt": data.rt,
      "rw": data.rw,
      "assignments": data.assignments,
      "email": data.email,
      "phone": data.phone,
      "phone_2": data.phone2,
      "position": data.position,
      "is_active": true
    });

    if (response != null && response.statusCode == 201) {
      var id = data.id!;
      if (data.pathKtp!.isNotEmpty) {
        await _postKtpFromUrl('/files/upload', data, id);
      }
      if (data.pathImage!.isNotEmpty) {
        await _postImageFromUrl('/files/upload', data, id);
      }
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> deleteOfficers(String idOfficer) =>
      _deleteOfficers('/officers/' + idOfficer);

  Future<bool> _deleteOfficers(
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
