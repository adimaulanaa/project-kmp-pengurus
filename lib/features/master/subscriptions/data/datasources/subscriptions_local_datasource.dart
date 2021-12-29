import 'package:kmp_pengurus_app/features/master/subscriptions/data/models/subscriptions_model.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SubscriptionsLocalDataSource {
  Future<void> cacheSubscriptions(SubscriptionsModel subscriptionsToCache);
  Future<SubscriptionsModel> getLastCacheSubscriptions();
}

class SubscriptionsLocalDataSourceImpl implements SubscriptionsLocalDataSource {
  SubscriptionsLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.dbServices,
  });

  final SharedPreferences sharedPreferences;
  final HiveDbServices dbServices;

  @override
  Future<void> cacheSubscriptions(
      SubscriptionsModel subscriptionsToCache) async {
    await _cacheSubscriptionsLocalStorage(subscriptionsToCache);
  }

  @override
  Future<SubscriptionsModel> getLastCacheSubscriptions() async {
    final data = await dbServices.getData(HiveDbServices.boxSubscription);
    SubscriptionsModel result = new SubscriptionsModel();
    if (data != null) {
      result = subscriptionsModelFromJson(data);
    }
    return result;
  }

  Future<void> _cacheSubscriptionsLocalStorage(
      SubscriptionsModel subscriptionsToCache) async {
    String data = subscriptionsModelToJson(subscriptionsToCache);
    await dbServices.addData(HiveDbServices.boxSubscription, data);
  }
}
