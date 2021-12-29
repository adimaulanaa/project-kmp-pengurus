import 'dart:io';
import 'package:kmp_pengurus_app/features/master/caretaker/data/models/caretaker_model.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/domain/entities/post_caretaker.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/framework/managers/http_manager.dart';

abstract class CaretakerRemoteDataSource {
  Future<CaretakerModel> getCaretaker();
  Future<bool> postCaretaker(PostCaretaker data);
  Future<bool> editCaretaker(PostCaretaker data);
}

class CaretakerRemoteDataSourceImpl implements CaretakerRemoteDataSource {
  CaretakerRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<CaretakerModel> getCaretaker() =>
      _getDasboardFromUrl('/caretakers/pagination');

  Future<CaretakerModel> _getDasboardFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "limit": -1,
      "page": 0,
      "sort": "name",
    });

    if (response != null && response.statusCode == 201) {
      return CaretakerModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> postCaretaker(PostCaretaker data) =>
      _postCaretakerFromUrl('/caretakers', data);

  Future<bool> _postCaretakerFromUrl(String url, PostCaretaker data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "id_card": data.idCard,
      "name": data.name,
      "gender": data.gender,
      "email": data.email,
      "phone": data.phone,
      "is_treasurer": data.isTreasurer
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> editCaretaker(PostCaretaker data) =>
      _editSubscriptionsFromUrl('/caretakers/' + data.id!, data);

  Future<bool> _editSubscriptionsFromUrl(
      String url, PostCaretaker data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.put(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "is_treasurer": data.isTreasurer
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

}
