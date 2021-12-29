import 'package:kmp_pengurus_app/features/bendahara/cash_book/data/models/cash_book_model.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FinancialStatementLocalDataSource {
  Future<void> cacheCashBook(CashBookModel cashBookToCache);
  Future<CashBookModel> getLastCacheCashBook();
}

class FinancialStatementLocalDataSourceImpl implements FinancialStatementLocalDataSource {
  FinancialStatementLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheCashBook(
      CashBookModel cashBookToCache) async {
    await _cacheCashBookLocalStorage(cashBookToCache);
  }

  @override
  Future<CashBookModel> getLastCacheCashBook() async {
    final data = await dbServices.getData(HiveDbServices.boxCashBook);
    CashBookModel result = new CashBookModel();
    if (data != null) {
      result = cashBookModelFromJson(data);
    }
    return result;
  }

  Future<void> _cacheCashBookLocalStorage(
      CashBookModel cashBookToCache) async {
    String data = cashBookModelToJson(cashBookToCache);
    await dbServices.addData(HiveDbServices.boxCashBook, data);
  }
}
