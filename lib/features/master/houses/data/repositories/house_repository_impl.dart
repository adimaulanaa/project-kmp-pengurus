import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/master/houses/data/datasources/house_local_datasource.dart';
import 'package:kmp_pengurus_app/features/master/houses/data/datasources/house_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/master/houses/data/models/house_model.dart';
import 'package:kmp_pengurus_app/features/master/houses/domain/entities/post_houses.dart';
import 'package:kmp_pengurus_app/features/master/houses/domain/repositories/house_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/core/network/network_info.dart';

class HousesRepositoryImpl implements HousesRepository {
  HousesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final HouseRemoteDataSource remoteDataSource;
  final HouseLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, HousesModel>> houses() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getHouse();
        await localDataSource.cacheHouse(remoteData);
        return Right(remoteData);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastCacheHouse();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, HousesModel>> housesFromCache() async {
    try {
      final localTrivia = await localDataSource.getLastCacheHouse();
      return Right(localTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> postHouse(PostHouses houses) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.postHouse(houses);
        return Right(remoteData);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
      }
    } else {
      return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, bool>> editHouse(PostHouses housesEdit) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.editHouse(housesEdit);
        return Right(remoteData);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
      }
    } else {
      return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteHouse(String housesDelete) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.deleteHouse(housesDelete);
        return Right(remoteData);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
      }
    } else {
      return Left(NetworkFailure(StringResources.NETWORK_FAILURE_MESSAGE));
    }
  }
}
