import 'package:kmp_pengurus_app/features/dues/data/models/dues_model.dart';
import 'package:kmp_pengurus_app/features/master/houses/data/models/house_model.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DuesLocalDataSource {
  Future<void> cacheHouse(HousesModel houseToCache);
  Future<HousesModel> getLastCacheHouse();
  Future<void> cacheDues(CitizenSubscriptionsModel houseToCache);
  Future<CitizenSubscriptionsModel> getLastCacheDues();
}

class DuesLocalDataSourceImpl implements DuesLocalDataSource {
  DuesLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheDues(CitizenSubscriptionsModel houseToCache) async {
    await _cacheDuesLocalStorage(houseToCache);
  }

  @override
  Future<CitizenSubscriptionsModel> getLastCacheDues() async {
    final data = await dbServices.getData(HiveDbServices.boxDues);
    CitizenSubscriptionsModel result = new CitizenSubscriptionsModel();
    if (data != null) {
      result = citizenSubscriptionsModelFromJson(data);
    }
    return result;
  }

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

  Future<void> _cacheDuesLocalStorage(
      CitizenSubscriptionsModel houseToCache) async {
    String data = citizenSubscriptionsModelToJson(houseToCache);
    await dbServices.addData(HiveDbServices.boxDues, data);
  }

  

  Future<void> _cacheHouseLocalStorage(
      HousesModel houseToCache) async {
    String data = housesModelToJson(houseToCache);
    await dbServices.addData(HiveDbServices.boxHouse, data);
  }
}
