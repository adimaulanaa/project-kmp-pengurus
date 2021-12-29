
import 'package:kmp_pengurus_app/features/master/houses/data/models/house_model.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HouseLocalDataSource {
  Future<void> cacheHouse(HousesModel houseToCache);
  Future<HousesModel> getLastCacheHouse();
}

class HouseLocalDataSourceImpl implements HouseLocalDataSource {
  HouseLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheHouse(
      HousesModel houseToCache) async {
    await _cacheHouseLocalStorage(houseToCache);
  }

  @override
  Future<HousesModel> getLastCacheHouse() async {
    final data = await dbServices.getData(HiveDbServices.boxHouse);
    HousesModel result = new HousesModel();
    if (data != null) {
      result = housesModelFromJson(data);
    }
    return result;
  }

  Future<void> _cacheHouseLocalStorage(
      HousesModel houseToCache) async {
    String data = housesModelToJson(houseToCache);
    await dbServices.addData(HiveDbServices.boxHouse, data);
  }
}
