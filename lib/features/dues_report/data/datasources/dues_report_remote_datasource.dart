import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/models/cash_book_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/cash_book/domain/entities/data.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_pengurus_app/framework/managers/http_manager.dart';

abstract class FinancialStatementRemoteDataSource {
  Future<CashBookModel> getCashBook(CashBookData dataCashBook);
  Future<String> getPdf(CashBookData getPdf);
}

class FinancialStatementRemoteDataSourceImpl
    implements FinancialStatementRemoteDataSource {
  FinancialStatementRemoteDataSourceImpl({
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
  Future<String> getPdf(CashBookData getPdf) => _getPdfFromurl(
      '/transactions/cash_book/pdf/' +
          getPdf.month.toString() +
          '/' +
          getPdf.year.toString() +
          '/' +
          getPdf.type.toString(),
      getPdf);

  Future<String> _getPdfFromurl(String url, CashBookData data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);
    var path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    String savePath = path! +
        "/LaporanKeuangan_${data.month}" +
        "_" +
        "${data.year}" +
        ".pdf";

    final response =
        await httpManager.download(url: url, path: savePath, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    });

    if (response != null && response.statusCode == 200) {
      return savePath;
    } else {
      throw ServerException();
    }
  }
}
