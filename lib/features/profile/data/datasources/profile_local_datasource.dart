import 'package:kmp_pengurus_app/features/profile/data/models/profile_model.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheProfile(ProfileModel profileToCache);
  Future<ProfileModel> getLastCacheProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheProfile(
      ProfileModel officersToCache) async {
    await _cacheOfficersLocalStorage(officersToCache);
  }

  @override
  Future<ProfileModel> getLastCacheProfile() async {
    final data = await dbServices.getData(HiveDbServices.boxProfile);
    ProfileModel result = new ProfileModel();
    if (data != null) {
      result = profileModelFromJson(data);
    }
    return result;
  }

  Future<void> _cacheOfficersLocalStorage(
      ProfileModel profileToCache) async {
    String data = profileModelToJson(profileToCache);
    await dbServices.addData(HiveDbServices.boxProfile, data);
  }
}
