import 'package:kmp_pengurus_app/features/master/officers/data/models/officers_model.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OfficersLocalDataSource {
  Future<void> cacheOfficers(OfficersModel officersToCache);
  Future<OfficersModel> getLastCacheOfficers();
}

class OfficersLocalDataSourceImpl implements OfficersLocalDataSource {
  OfficersLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheOfficers(OfficersModel officersToCache) async {
    await _cacheOfficersLocalStorage(officersToCache);
  }

  @override
  Future<OfficersModel> getLastCacheOfficers() async {
    final data = await dbServices.getData(HiveDbServices.boxOfficer);
    OfficersModel result = new OfficersModel();
    if (data != null) {
      result = officersModelFromJson(data);
    }
    return result;
  }

  Future<void> _cacheOfficersLocalStorage(OfficersModel officersToCache) async {
    String data = officersModelToJson(officersToCache);
    await dbServices.addData(HiveDbServices.boxOfficer, data);
  }
}
