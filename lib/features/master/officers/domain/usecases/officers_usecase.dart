import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/master/officers/data/models/officers_model.dart';
import 'package:kmp_pengurus_app/features/master/officers/domain/entities/post_officers.dart';
import 'package:kmp_pengurus_app/features/master/officers/domain/repositories/officers_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';

class OfficersUseCase implements UseCase<OfficersModel, NoParams> {
  OfficersUseCase(this.repository);

  final OfficersRepository repository;

  @override
  Future<Either<Failure, OfficersModel>> call(NoParams params) =>
      repository.officers();
}

class OfficersFromCacheUseCase
    implements UseCase<OfficersModel, NoParams> {
  OfficersFromCacheUseCase(this.repository);

  final OfficersRepository repository;

  @override
  Future<Either<Failure, OfficersModel>> call(NoParams params) =>
      repository.officersFromCache();
}

class PostOfficerUseCase implements UseCase<bool, PostOfficers> {

  PostOfficerUseCase(this.repository);

  final OfficersRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostOfficers params) =>
      repository.postOfficer(params);
}

class EditOfficerUseCase implements UseCase<bool, PostOfficers> {

  EditOfficerUseCase(this.repository);

  final OfficersRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostOfficers params) =>
      repository.editOfficer(params);
}

class DeleteOfficerUseCase implements UseCase<bool, String> {

  DeleteOfficerUseCase(this.repository);

  final OfficersRepository repository;

  @override
  Future<Either<Failure, bool>> call(String params) =>
      repository.deleteOfficer(params);
}
