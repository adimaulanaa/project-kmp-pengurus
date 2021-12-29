import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/master/houses/data/models/house_model.dart';
import 'package:kmp_pengurus_app/features/master/houses/domain/entities/post_houses.dart';
import 'package:kmp_pengurus_app/features/master/houses/domain/repositories/house_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';

class HousesUseCase implements UseCase<HousesModel, NoParams> {
  HousesUseCase(this.repository);

  final HousesRepository repository;

  @override
  Future<Either<Failure, HousesModel>> call(NoParams params) =>
      repository.houses();
}

class HousesFromCacheUseCase
    implements UseCase<HousesModel, NoParams> {
  HousesFromCacheUseCase(this.repository);

  final HousesRepository repository;

  @override
  Future<Either<Failure, HousesModel>> call(NoParams params) =>
      repository.housesFromCache();
}

class PostHouseUseCase implements UseCase<bool, PostHouses> {

  PostHouseUseCase(this.repository);

  final HousesRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostHouses params) =>
      repository.postHouse(params);
}

class EditHouseUseCase implements UseCase<bool, PostHouses> {

  EditHouseUseCase(this.repository);

  final HousesRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostHouses params) =>
      repository.editHouse(params);
}

class DeleteHouseUseCase implements UseCase<bool, String> {

  DeleteHouseUseCase(this.repository);

  final HousesRepository repository;

  @override
  Future<Either<Failure, bool>> call(String params) =>
      repository.deleteHouse(params);
}
