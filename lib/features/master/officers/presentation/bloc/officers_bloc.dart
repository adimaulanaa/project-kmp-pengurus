import 'dart:async';
import 'package:kmp_pengurus_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/dashboard/data/models/region_model.dart';
import 'package:kmp_pengurus_app/features/master/officers/domain/usecases/officers_usecase.dart';
import 'package:kmp_pengurus_app/features/master/officers/presentation/bloc/officers_event.dart';
import 'package:kmp_pengurus_app/features/master/officers/presentation/bloc/officers_state.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';

class OfficersBloc extends Bloc<OfficersEvent, OfficersState> {
  OfficersBloc({
    required OfficersUseCase officers,
    required HiveDbServices dbServices,
    required PostOfficerUseCase addOfficers,
    required EditOfficerUseCase editOfficers,
    required DeleteOfficerUseCase deleteOfficers,
  })  : _officers = officers,
        _dbServices = dbServices,
        _addOfficers = addOfficers,
        _editOfficers = editOfficers,
        _deleteOfficers = deleteOfficers,
        super(OfficersInitial());

  final OfficersUseCase _officers;
  final PostOfficerUseCase _addOfficers;
  final EditOfficerUseCase _editOfficers;
  final DeleteOfficerUseCase _deleteOfficers;
  final HiveDbServices _dbServices;

  @override
  Stream<OfficersState> mapEventToState(
    OfficersEvent event,
  ) async* {
    if (event is LoadOfficers) {
      yield OfficersLoading();
      var stringUser = await _dbServices.getUser();
      var user = userModelFromJson(stringUser);

      final failureOrSuccess = await _officers(NoParams());
      yield failureOrSuccess.fold(
        (failure) => OfficersFailure(error: mapFailureToMessage(failure)),
        (success) => OfficersLoaded(data: success.paginate!.docs, user: user),
      );
    }
    if (event is AddLoadOfficers) {
      final data = await _dbServices.getData(HiveDbServices.boxDashboard);
      if (data == null) {
        yield OfficersFailure(error: 'Data Tidak Ditemukan');
      }
      final dashboard = dashboardModelFromJson(data.toString());
      final listVillage = dashboard.client!.villages;
      final listJob = dashboard.positions;
      final listRwRt = dashboard.villageRwRts;
      final dataRegion = await _dbServices.getData(HiveDbServices.boxRegions);

      if (dataRegion == null) {
        yield OfficersFailure(error: 'Data Tidak Ditemukan1');
      } else {
        final listRegion = regionsModelFromJson(dataRegion);
        yield AddOfficersLoaded(
            listVillage: listVillage,
            listRwRt: listRwRt,
            listRegion: listRegion,
            listJob: listJob);
      }
    }

    if (event is EditLoadOfficers) {
      final data = await _dbServices.getData(HiveDbServices.boxDashboard);
      if (data == null) {
        yield OfficersFailure(error: 'Data Tidak Ditemukan');
      }
      final dashboard = dashboardModelFromJson(data.toString());
      final listVillage = dashboard.client!.villages;
      final listJob = dashboard.positions;
      final listRwRt = dashboard.villageRwRts;
      final dataRegion = await _dbServices.getData(HiveDbServices.boxRegions);

      final listRegion = regionsModelFromJson(dataRegion);

      yield EditOfficersLoaded(
          listVillage: listVillage,
          listRwRt: listRwRt,
          listRegion: listRegion,
          listJob: listJob);
    }

    if (event is AddOfficersEvent) {
      final failureOrSuccess = await _addOfficers(event.officers);
      yield failureOrSuccess.fold(
          (failure) => OfficersFailure(error: mapFailureToMessage(failure)),
          (loaded) => OfficersSuccess(isSuccess: loaded));
    }

    if (event is EditOfficersEvent) {
      final failureOrSuccess = await _editOfficers(event.officersEdit);
      yield failureOrSuccess.fold(
          (failure) => OfficersFailure(error: mapFailureToMessage(failure)),
          (loaded) => EditOfficersSuccess(isSuccess: loaded));
    }

    if (event is DeleteOfficersEvent) {
      final failureOrSuccess = await _deleteOfficers(event.idOfficer);
      yield failureOrSuccess.fold(
          (failure) => OfficersFailure(error: mapFailureToMessage(failure)),
          (loaded) => DeleteOfficersSuccess(isSuccess: loaded));
    }
  }
}
