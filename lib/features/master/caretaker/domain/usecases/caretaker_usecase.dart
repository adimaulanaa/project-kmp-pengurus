import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/data/models/caretaker_model.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/domain/entities/post_caretaker.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/domain/repositories/caretaker_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';

class CaretakerUseCase implements UseCase<CaretakerModel, NoParams> {
  CaretakerUseCase(this.repository);

  final CaretakerRepository repository;

  @override
  Future<Either<Failure, CaretakerModel>> call(NoParams params) =>
      repository.caretaker();
}

class CaretakerFromCacheUseCase
    implements UseCase<CaretakerModel, NoParams> {
  CaretakerFromCacheUseCase(this.repository);

  final CaretakerRepository repository;

  @override
  Future<Either<Failure, CaretakerModel>> call(NoParams params) =>
      repository.caretakerFromCache();
}

class PostCaretakerUseCase implements UseCase<bool, PostCaretaker> {
  PostCaretakerUseCase(this.repository);

  final CaretakerRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostCaretaker params) =>
      repository.postCaretaker(params);
}

class EditCaretakerUseCase implements UseCase<bool, PostCaretaker> {
  EditCaretakerUseCase(this.repository);

  final CaretakerRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostCaretaker params) =>
      repository.editCaretaker(params);
}
