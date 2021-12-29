import 'package:kmp_pengurus_app/features/master/category/data/models/category_model.dart';

abstract class CategoryState {
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  CategoryLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  CategoryModel? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}


class AddCategoryLoaded extends CategoryState {
}

class EditCategoryLoaded extends CategoryState {
}

class CategorySuccess extends CategoryState {
  final bool isSuccess;

  CategorySuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class DeleteCategorySuccess extends CategoryState {
  final bool isSuccess;

  DeleteCategorySuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class CategoryFailure extends CategoryState {
  CategoryFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'category Failure { error: $error }';
}
