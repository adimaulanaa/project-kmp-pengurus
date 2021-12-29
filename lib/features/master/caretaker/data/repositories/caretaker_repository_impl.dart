import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/data/datasources/caretaker_local_datasource.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/data/datasources/caretaker_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/data/models/caretaker_model.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/domain/entities/post_caretaker.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/domain/repositories/caretaker_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/core/network/network_info.dart';

class CaretakerRepositoryImpl implements CaretakerRepository {
  CaretakerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final CaretakerRemoteDataSource remoteDataSource;
  final CaretakerLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, CaretakerModel>> caretaker() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getCaretaker();
        await localDataSource.cacheCaretaker(remoteData);
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
        final localTrivia = await localDataSource.getLastCacheCaretaker();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, CaretakerModel>> caretakerFromCache() async {
    try {
      final localTrivia = await localDataSource.getLastCacheCaretaker();
      return Right(localTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> postCaretaker(PostCaretaker caretaker) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.postCaretaker(caretaker);
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
  Future<Either<Failure, bool>> editCaretaker(
      PostCaretaker caretakerEdit) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.editCaretaker(caretakerEdit);
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
