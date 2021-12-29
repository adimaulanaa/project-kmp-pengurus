import 'dart:io';
import 'package:kmp_pengurus_app/features/master/subscriptions/data/models/subscriptions_model.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/domain/entities/post_subscriptions.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/framework/managers/http_manager.dart';

abstract class SubscriptionsRemoteDataSource {
  Future<SubscriptionsModel> getSubscriptions();
  Future<bool> postSubscriptions(PostSubscriptions data);
  Future<bool> editSubscriptions(PostSubscriptions data);
  Future<bool> deleteSubscriptions(String idSubscription);
}

class SubscriptionsRemoteDataSourceImpl
    implements SubscriptionsRemoteDataSource {
  SubscriptionsRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<SubscriptionsModel> getSubscriptions() =>
      _getDasboardFromUrl('/subscriptions/pagination');

  Future<SubscriptionsModel> _getDasboardFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "limit": -1,
      "page": 0,
      "sort": "name",
    });

    if (response != null && response.statusCode == 201) {
      return SubscriptionsModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> postSubscriptions(PostSubscriptions data) =>
      _postSubscriptionsFromUrl('/subscriptions', data);

  Future<bool> _postSubscriptionsFromUrl(
      String url, PostSubscriptions data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "name": data.name,
      "description": data.description,
      "amount": data.amount,
      "subscription_category": data.subscriptionCategory,
      "effective_date_string": data.effectiveDateString,
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> editSubscriptions(PostSubscriptions data) =>
      _editSubscriptionsFromUrl('/subscriptions/' + data.id!, data);

  Future<bool> _editSubscriptionsFromUrl(
      String url, PostSubscriptions data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.put(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "name": data.name,
      "description": data.description,
      "amount": data.amount,
      "subscription_category": data.subscriptionCategory,
      "effective_date_string": data.effectiveDateString,
      "is_active": data.isActive
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> deleteSubscriptions(String idSubscription) =>
      _deleteSubscriptions('/subscriptions/' + idSubscription);

  Future<bool> _deleteSubscriptions(
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
