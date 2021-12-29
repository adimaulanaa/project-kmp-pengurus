import 'dart:io';
import 'package:kmp_pengurus_app/features/master/category/data/models/category_model.dart';
import 'package:kmp_pengurus_app/features/master/category/domain/entities/post_category.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/framework/managers/http_manager.dart';

abstract class CategoryRemoteDataSource {
  Future<CategoryModel> getCategory();
  Future<bool> postCategory(PostCategory data);
  Future<bool> editCategory(PostCategory data);
  Future<bool> deleteCategory(String idCategory);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<CategoryModel> getCategory() =>
      _getDasboardFromUrl('/accounts/pagination');

  Future<CategoryModel> _getDasboardFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "limit": -1,
      "page": 0,
      "sort": "name",
    });

    if (response != null && response.statusCode == 201) {
      return CategoryModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> postCategory(PostCategory data) =>
      _postCategoryFromUrl('/accounts', data);

  Future<bool> _postCategoryFromUrl(String url, PostCategory data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "name": data.name,
      "description": data.description
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> editCategory(PostCategory data) =>
      _editSubscriptionsFromUrl('/accounts/' + data.id!, data);

  Future<bool> _editSubscriptionsFromUrl(String url, PostCategory data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.put(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "name": data.name,
      "description": data.description,
      "is_active": true
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> deleteCategory(String idCategory) =>
      _deleteCategory('/accounts/' + idCategory);

  Future<bool> _deleteCategory(
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
