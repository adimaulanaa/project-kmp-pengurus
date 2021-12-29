import 'package:kmp_pengurus_app/features/bendahara/deposit/data/models/deposit_model.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DepositLocalDataSource {
  Future<void> cacheDeposit(DepositModel depositToCache);
  Future<DepositModel> getLastCacheDeposit();
}

class DepositLocalDataSourceImpl implements DepositLocalDataSource {
  DepositLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheDeposit(
      DepositModel depositToCache) async {
    await _cacheDepositLocalStorage(depositToCache);
  }

  @override
  Future<DepositModel> getLastCacheDeposit() async {
    final data = await dbServices.getData(HiveDbServices.boxDeposit);
    DepositModel result = new DepositModel();
    if (data != null) {
      result = depositModelFromJson(data);
    }
    return result;
  }

  Future<void> _cacheDepositLocalStorage(
      DepositModel depositToCache) async {
    String data = depositModelToJson(depositToCache);
    await dbServices.addData(HiveDbServices.boxDeposit, data);
  }
}
