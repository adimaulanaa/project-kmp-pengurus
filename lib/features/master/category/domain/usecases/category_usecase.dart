import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/master/category/data/models/category_model.dart';
import 'package:kmp_pengurus_app/features/master/category/domain/entities/post_category.dart';
import 'package:kmp_pengurus_app/features/master/category/domain/repositories/category_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';

class CategoryUseCase implements UseCase<CategoryModel, NoParams> {
  CategoryUseCase(this.repository);

  final CategoryRepository repository;

  @override
  Future<Either<Failure, CategoryModel>> call(NoParams params) =>
      repository.category();
}

class CategoryFromCacheUseCase
    implements UseCase<CategoryModel, NoParams> {
  CategoryFromCacheUseCase(this.repository);

  final CategoryRepository repository;

  @override
  Future<Either<Failure, CategoryModel>> call(NoParams params) =>
      repository.categoryFromCache();
}

class PostCategoryUseCase implements UseCase<bool, PostCategory> {
  PostCategoryUseCase(this.repository);

  final CategoryRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostCategory params) =>
      repository.postCategory(params);
}

class EditCategoryUseCase implements UseCase<bool, PostCategory> {
  EditCategoryUseCase(this.repository);

  final CategoryRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostCategory params) =>
      repository.editCategory(params);
}

class DeleteCategoryUseCase implements UseCase<bool, String> {

  DeleteCategoryUseCase(this.repository);

  final CategoryRepository repository;

  @override
  Future<Either<Failure, bool>> call(String params) =>
      repository.deleteCategory(params);
}