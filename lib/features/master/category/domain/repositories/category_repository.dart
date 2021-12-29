import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/master/category/data/models/category_model.dart';
import 'package:kmp_pengurus_app/features/master/category/domain/entities/post_category.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';

abstract class CategoryRepository {
  
  Future<Either<Failure, bool>> postCategory(PostCategory category);
  Future<Either<Failure, bool>> editCategory(PostCategory categoryEdit);
   Future<Either<Failure, bool>> deleteCategory(String categoryId);
  
  Future<Either<Failure, CategoryModel>> category();
  Future<Either<Failure, CategoryModel>> categoryFromCache();
}
