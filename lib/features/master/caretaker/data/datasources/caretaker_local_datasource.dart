import 'package:kmp_pengurus_app/features/master/caretaker/data/models/caretaker_model.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CaretakerLocalDataSource {
  Future<void> cacheCaretaker(CaretakerModel caretakerToCache);
  Future<CaretakerModel> getLastCacheCaretaker();
}

class CaretakerLocalDataSourceImpl implements CaretakerLocalDataSource {
  CaretakerLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheCaretaker(
      CaretakerModel caretakerToCache) async {
    await _cacheCaretakerLocalStorage(caretakerToCache);
  }

  @override
  Future<CaretakerModel> getLastCacheCaretaker() async {
    final data = await dbServices.getData(HiveDbServices.boxCaretaker);
    CaretakerModel result = new CaretakerModel();
    if (data != null) {
      result = caretakerModelFromJson(data);
    }
    return result;
  }

  Future<void> _cacheCaretakerLocalStorage(
      CaretakerModel caretakerToCache) async {
    String data = caretakerModelToJson(caretakerToCache);
    await dbServices.addData(HiveDbServices.boxCaretaker, data);
  }
}
