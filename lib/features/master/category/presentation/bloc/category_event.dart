import 'package:equatable/equatable.dart';
import 'package:kmp_pengurus_app/features/master/category/domain/entities/post_category.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategory extends CategoryEvent {
  
}

class AddLoadCategory extends CategoryEvent {
  
}

class EditLoadCategory extends CategoryEvent {
  
}

class AddCategoryEvent extends CategoryEvent {
  final PostCategory category;

  const AddCategoryEvent({
    required this.category,
  });
}

class EditCategoryEvent extends CategoryEvent {
  final PostCategory categoryEdit;

  const EditCategoryEvent({
    required this.categoryEdit,
  });
}

class DeleteCategoryEvent extends CategoryEvent {
  final String idCategory;

  const DeleteCategoryEvent({
    required this.idCategory,
  });
}

