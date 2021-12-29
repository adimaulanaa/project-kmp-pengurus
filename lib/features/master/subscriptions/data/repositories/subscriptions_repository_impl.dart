import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/data/datasources/subscriptions_local_datasource.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/data/datasources/subscriptions_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/data/models/subscriptions_model.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/domain/entities/post_subscriptions.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/domain/repositories/subscriptions_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/core/network/network_info.dart';

class SubscriptionsRepositoryImpl implements SubscriptionsRepository {
  SubscriptionsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final SubscriptionsRemoteDataSource remoteDataSource;
  final SubscriptionsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, SubscriptionsModel>> subscriptions() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getSubscriptions();
        await localDataSource.cacheSubscriptions(remoteData);
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
        final localTrivia = await localDataSource.getLastCacheSubscriptions();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, SubscriptionsModel>> subscriptionsFromCache() async {
    try {
      final localTrivia = await localDataSource.getLastCacheSubscriptions();
      return Right(localTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> postSubscription(
      PostSubscriptions subscriptions) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData =
            await remoteDataSource.postSubscriptions(subscriptions);
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
  Future<Either<Failure, bool>> editSubscription(
      PostSubscriptions subscriptionsEdit) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData =
            await remoteDataSource.editSubscriptions(subscriptionsEdit);
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
  Future<Either<Failure, bool>> deleteSubscription(
      String subscriptionsDelete) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData =
            await remoteDataSource.deleteSubscriptions(subscriptionsDelete);
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
