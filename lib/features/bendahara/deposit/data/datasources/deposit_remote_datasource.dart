import 'dart:io';
import 'package:kmp_pengurus_app/features/bendahara/deposit/data/models/deposit_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/domain/entities/post_deposit.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/framework/managers/http_manager.dart';

abstract class DepositRemoteDataSource {
  Future<DepositModel> getDeposit();
  Future<bool> postDeposit(PostDeposit data);
}

class DepositRemoteDataSourceImpl implements DepositRemoteDataSource {
  DepositRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<DepositModel> getDeposit() =>
      _getDepositFromUrl('/users/cash_deposit_transaction');

  Future<DepositModel> _getDepositFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.get(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    });

    if (response != null && response.statusCode == 201) {
      return DepositModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> postDeposit(PostDeposit data) =>
      _postDepositFromUrl('/transactions/cash_deposit', data);

  Future<bool> _postDepositFromUrl(String url, PostDeposit data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.put(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "add_by": data.addBy,
      "transactions": data.transactions
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }
}
