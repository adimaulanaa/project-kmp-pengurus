import 'dart:async';
import 'package:kmp_pengurus_app/features/master/category/domain/usecases/category_usecase.dart';
import 'package:kmp_pengurus_app/features/master/category/presentation/bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:kmp_pengurus_app/framework/managers/helper.dart';
import 'package:kmp_pengurus_app/framework/managers/hive_db_helper.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({
    required CategoryUseCase category,
    required CategoryFromCacheUseCase categoryFromCache,
    required HiveDbServices dbServices,
    required PostCategoryUseCase addCategory,
    required EditCategoryUseCase editCategory,
    required DeleteCategoryUseCase deleteCategory,
  })  : _category = category,
        _categoryFromCache = categoryFromCache,
        _addCategory = addCategory,
        _editCategory = editCategory,
        _deleteCategory = deleteCategory,
        super(CategoryInitial());

  final CategoryUseCase _category;
  final PostCategoryUseCase _addCategory;
  final EditCategoryUseCase _editCategory;
  final DeleteCategoryUseCase _deleteCategory;
  final CategoryFromCacheUseCase _categoryFromCache;

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is LoadCategory) {
      yield CategoryLoading();
      final failureOrSuccessFromCache = await _categoryFromCache(NoParams());
      yield failureOrSuccessFromCache.fold(
        (failure) => CategoryFailure(error: mapFailureToMessage(failure)),
        (success) => CategoryLoaded(
          data: success,
        ),
      );

      final failureOrSuccess = await _category(NoParams());
      yield failureOrSuccess.fold(
        (failure) => CategoryFailure(error: mapFailureToMessage(failure)),
        (success) => CategoryLoaded(data: success),
      );
    }
    if (event is AddLoadCategory) {
      yield AddCategoryLoaded();
    }

    if (event is EditLoadCategory) {
      yield EditCategoryLoaded();
    }

    if (event is AddCategoryEvent) {
      final failureOrSuccess = await _addCategory(event.category);
      yield failureOrSuccess.fold(
          (failure) => CategoryFailure(error: mapFailureToMessage(failure)),
          (loaded) => CategorySuccess(isSuccess: loaded));
    }

    if (event is EditCategoryEvent) {
      final failureOrSuccess = await _editCategory(event.categoryEdit);
      yield failureOrSuccess.fold(
          (failure) => CategoryFailure(error: mapFailureToMessage(failure)),
          (loaded) => CategorySuccess(isSuccess: loaded));
    }

    if (event is DeleteCategoryEvent) {
      final failureOrSuccess = await _deleteCategory(event.idCategory);
      yield failureOrSuccess.fold(
          (failure) => CategoryFailure(error: "Gagal Menambahkan Data"),
          (loaded) => DeleteCategorySuccess(isSuccess: loaded));
    }
  }
}
