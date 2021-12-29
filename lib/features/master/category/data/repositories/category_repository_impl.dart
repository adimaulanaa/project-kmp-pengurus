import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/config/string_resources.dart';
import 'package:kmp_pengurus_app/features/master/category/data/datasources/category_local_datasource.dart';
import 'package:kmp_pengurus_app/features/master/category/data/datasources/category_remote_datasource.dart';
import 'package:kmp_pengurus_app/features/master/category/data/models/category_model.dart';
import 'package:kmp_pengurus_app/features/master/category/domain/entities/post_category.dart';
import 'package:kmp_pengurus_app/features/master/category/domain/repositories/category_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_pengurus_app/framework/core/network/network_info.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, CategoryModel>> category() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getCategory();
        await localDataSource.cacheCategory(remoteData);
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
        final localTrivia = await localDataSource.getLastCacheCategory();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, CategoryModel>> categoryFromCache() async {
    try {
      final localTrivia = await localDataSource.getLastCacheCategory();
      return Right(localTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> postCategory(PostCategory category) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.postCategory(category);
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
  Future<Either<Failure, bool>> editCategory(PostCategory categoryEdit) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.editCategory(categoryEdit);
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
  Future<Either<Failure, bool>> deleteCategory(String categoryDelete) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData =
            await remoteDataSource.deleteCategory(categoryDelete);
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
