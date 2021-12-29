import 'dart:async';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/domain/usecases/subscriptions_usecase.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  SubscriptionsBloc({
    required SubscriptionsUseCase subscriptions,
    required SubscriptionsFromCacheUseCase subscriptionsFromCache,
    required HiveDbServices dbServices,
    required PostSubscriptionUseCase addSubscriptions,
    required EditSubscriptionUseCase editSubscriptions,
    required DeleteSubscriptionUseCase deleteSubscriptions,
  })  : _subscriptions = subscriptions,
        _subscriptionsFromCache = subscriptionsFromCache,
        _dbServices = dbServices,
        _addSubscriptions = addSubscriptions,
        _editSubscriptions = editSubscriptions,
        _deleteSubscriptions = deleteSubscriptions,
        super(SubscriptionsInitial());

  final SubscriptionsUseCase _subscriptions;
  final PostSubscriptionUseCase _addSubscriptions;
  final EditSubscriptionUseCase _editSubscriptions;
  final DeleteSubscriptionUseCase _deleteSubscriptions;
  final SubscriptionsFromCacheUseCase _subscriptionsFromCache;
  final HiveDbServices _dbServices;

  @override
  Stream<SubscriptionsState> mapEventToState(
    SubscriptionsEvent event,
  ) async* {
    if (event is LoadSubscriptions) {
      yield SubscriptionsLoading();
      final failureOrSuccessFromCache =
          await _subscriptionsFromCache(NoParams());
      yield failureOrSuccessFromCache.fold(
        (failure) => SubscriptionsFailure(error: mapFailureToMessage(failure)),
        (success) => SubscriptionsLoaded(
          data: success,
        ),
      );

      final failureOrSuccess = await _subscriptions(NoParams());
      yield failureOrSuccess.fold(
        (failure) => SubscriptionsFailure(error: mapFailureToMessage(failure)),
        (success) => SubscriptionsLoaded(data: success),
      );
    }
    if (event is AddLoadSubscriptions) {
      final data = await _dbServices.getData(HiveDbServices.boxDashboard);
      
      if (data == null) {
        yield SubscriptionsFailure(
            error: 'Data Kategori Iuran Tidak Ditemukan');
      }
      final dashboard = dashboardModelFromJson(data.toString());
      final listCategory = dashboard.subscriptionCategories;
      yield AddSubscriptionsLoaded(data: listCategory);
    }

    if (event is EditLoadSubscriptions) {
      final data = await _dbServices.getData(HiveDbServices.boxDashboard);
      if (data == null) {
        yield SubscriptionsFailure(
            error: 'Data Kategori Iuran Tidak Ditemukan');
      }
      final dashboard = dashboardModelFromJson(data.toString());
      final listCategory = dashboard.subscriptionCategories;
      yield EditSubscriptionsLoaded(data: listCategory);
    }

    if (event is AddSubscriptionsEvent) {
      final failureOrSuccess = await _addSubscriptions(event.subscriptions);
      yield failureOrSuccess.fold(
          (failure) => SubscriptionsFailure(error: mapFailureToMessage(failure)),
          (loaded) => SubscriptionsSuccess(isSuccess: loaded));
    }

    if (event is EditSubscriptionsEvent) {
      final failureOrSuccess = await _editSubscriptions(event.subscriptionsEdit);
      yield failureOrSuccess.fold(
          (failure) => SubscriptionsFailure(error: mapFailureToMessage(failure)),
          (loaded) => SubscriptionsSuccess(isSuccess: loaded));
    }

    if (event is DeleteSubscriptionsEvent) {
      final failureOrSuccess = await _deleteSubscriptions(event.idSubs);
      yield failureOrSuccess.fold(
          (failure) => SubscriptionsFailure(error: mapFailureToMessage(failure)),
          (loaded) => DeleteSubscriptionsSuccess(isSuccess: loaded));
    }
  }
}
