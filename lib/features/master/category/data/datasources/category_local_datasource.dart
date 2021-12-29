import 'package:kmp_pengurus_app/features/master/category/data/models/category_model.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CategoryLocalDataSource {
  Future<void> cacheCategory(CategoryModel categoryToCache);
  Future<CategoryModel> getLastCacheCategory();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  CategoryLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheCategory(
      CategoryModel categoryToCache) async {
    await _cacheCategoryLocalStorage(categoryToCache);
  }

  @override
  Future<CategoryModel> getLastCacheCategory() async {
    final data = await dbServices.getData(HiveDbServices.boxCategory);
    CategoryModel result = new CategoryModel();
    if (data != null) {
      result = categoryModelFromJson(data);
    }
    return result;
  }

  Future<void> _cacheCategoryLocalStorage(
      CategoryModel categoryToCache) async {
    String data = categoryModelToJson(categoryToCache);
    await dbServices.addData(HiveDbServices.boxCategory, data);
  }
}
