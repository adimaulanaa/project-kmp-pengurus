import 'dart:io';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/models/cash_book_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/data.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/post_cash_book.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/framework/managers/http_manager.dart';

abstract class CashBookRemoteDataSource {
  Future<CashBookModel> getCashBook(CashBookData dataCashBook);
  Future<bool> postCashBook(PostCashBook data);
}

class CashBookRemoteDataSourceImpl implements CashBookRemoteDataSource {
  CashBookRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<CashBookModel> getCashBook(CashBookData data) => _getCashBookFromUrl(
      '/transactions/cash_book/' +
          data.month.toString() +
          '/' +
          data.year.toString(),
      data);

  Future<CashBookModel> _getCashBookFromUrl(
      String url, CashBookData data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);
    final response = await httpManager.get(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    });

    if (response != null && response.statusCode == 201) {
      return CashBookModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }


  @override
  Future<bool> postCashBook(PostCashBook data) =>
      _postCashBookFromUrl('/transactions/cash_book', data);

  Future<bool> _postCashBookFromUrl(String url, PostCashBook data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "name": data.name,
      "price": data.price,
      "date_string": data.dateString,
      "account": data.account,
      "type": data.type
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }
}
