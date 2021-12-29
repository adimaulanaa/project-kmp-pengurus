import 'dart:async';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/master/houses/domain/usecases/house_usecase.dart';
import 'package:kmp_pengurus_app/features/master/houses/presentation/bloc/house_event.dart';
import 'package:kmp_pengurus_app/features/master/houses/presentation/bloc/house_state.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';

class HousesBloc extends Bloc<HousesEvent, HousesState> {
  HousesBloc({
    required HousesUseCase houses,
    required HousesFromCacheUseCase housesFromCache,
    required HiveDbServices dbServices,
    required PostHouseUseCase addHouses,
    required EditHouseUseCase editHouses,
    required DeleteHouseUseCase deleteHouses,
  })  : _houses = houses,
        _housesFromCache = housesFromCache,
        _dbServices = dbServices,
        _addHouses = addHouses,
        _editHouses = editHouses,
        _deleteHouses = deleteHouses,
        super(HousesInitial());

  final HousesUseCase _houses;
  final PostHouseUseCase _addHouses;
  final EditHouseUseCase _editHouses;
  final DeleteHouseUseCase _deleteHouses;
  final HousesFromCacheUseCase _housesFromCache;
  final HiveDbServices _dbServices;

  @override
  Stream<HousesState> mapEventToState(
    HousesEvent event,
  ) async* {
    if (event is LoadHouses) {
      yield HousesLoading();
      final failureOrSuccessFromCache = await _housesFromCache(NoParams());
      yield failureOrSuccessFromCache.fold(
        (failure) => HousesFailure(error: mapFailureToMessage(failure)),
        (success) => HousesLoaded(
          data: success,
        ),
      );

      final failureOrSuccess = await _houses(NoParams());
      yield failureOrSuccess.fold(
        (failure) => HousesFailure(error: mapFailureToMessage(failure)),
        (success) => HousesLoaded(data: success),
      );
    }
    if (event is AddLoadHouses) {
      final data = await _dbServices.getData(HiveDbServices.boxDashboard);

      if (data == null) {
        yield HousesFailure(error: 'Data Tidak Ditemukan');
      } else {
        final dashboard = dashboardModelFromJson(data.toString());
        final listCategory = dashboard.subscriptions;
        final listVillage = dashboard.client!.villages;
        final listRwRt = dashboard.villageRwRts;

        yield AddHousesLoaded(
            data: listCategory, listVillage: listVillage, listRwRt: listRwRt);
      }
    }

    if (event is EditLoadHouses) {
      final data = await _dbServices.getData(HiveDbServices.boxDashboard);
      if (data == null) {
        yield HousesFailure(error: 'Data Tidak Ditemukan');
      } else {
        final dashboard = dashboardModelFromJson(data.toString());
        final listCategory = dashboard.subscriptions;
        final listVillage = dashboard.client!.villages;
        final listRwRt = dashboard.villageRwRts;

        yield EditHousesLoaded(
            data: listCategory, listVillage: listVillage, listRwRt: listRwRt);
      }
    }

    if (event is AddHousesEvent) {
      final failureOrSuccess = await _addHouses(event.houses);
      yield failureOrSuccess.fold(
          (failure) => HousesFailure(error: mapFailureToMessage(failure)),
          (loaded) => HousesSuccess(isSuccess: loaded));
    }

    if (event is EditHousesEvent) {
      final failureOrSuccess = await _editHouses(event.housesEdit);
      yield failureOrSuccess.fold(
          (failure) => HousesFailure(error: mapFailureToMessage(failure)),
          (loaded) => HousesSuccess(isSuccess: loaded));
    }

    if (event is DeleteHousesEvent) {
      final failureOrSuccess = await _deleteHouses(event.idHouse);
      yield failureOrSuccess.fold(
          (failure) => HousesFailure(error: mapFailureToMessage(failure)),
          (loaded) => DeleteHousesSuccess(isSuccess: loaded));
    }
  }
}
