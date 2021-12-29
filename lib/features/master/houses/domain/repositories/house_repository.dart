import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/master/houses/data/models/house_model.dart';
import 'package:kmp_pengurus_app/features/master/houses/domain/entities/post_houses.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';

abstract class HousesRepository {
  
  Future<Either<Failure, bool>> postHouse(PostHouses houses);
  Future<Either<Failure, bool>> editHouse(PostHouses housesEdit);
  Future<Either<Failure, bool>> deleteHouse(String housesDelete);
  Future<Either<Failure, HousesModel>> houses();
  Future<Either<Failure, HousesModel>> housesFromCache();
}
