import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/data/datasources/Deposit_local_datasource.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/data/datasources/deposit_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/data/models/deposit_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/domain/entities/post_deposit.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/domain/repositories/deposit_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/core/network/network_info.dart';

class DepositRepositoryImpl implements DepositRepository {
  DepositRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final DepositRemoteDataSource remoteDataSource;
  final DepositLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, DepositModel>> deposit() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getDeposit();
        await localDataSource.cacheDeposit(remoteData);
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
        final localTrivia = await localDataSource.getLastCacheDeposit();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, DepositModel>> depositFromCache() async {
    try {
      final localTrivia = await localDataSource.getLastCacheDeposit();
      return Right(localTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> postDeposit(PostDeposit deposit) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.postDeposit(deposit);
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
