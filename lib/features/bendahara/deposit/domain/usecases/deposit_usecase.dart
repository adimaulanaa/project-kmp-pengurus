import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/data/models/deposit_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/domain/entities/post_deposit.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/domain/repositories/deposit_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';

class DepositUseCase implements UseCase<DepositModel, NoParams> {
  DepositUseCase(this.repository);

  final DepositRepository repository;

  @override
  Future<Either<Failure, DepositModel>> call(NoParams params) =>
      repository.deposit();
}

class DepositFromCacheUseCase implements UseCase<DepositModel, NoParams> {
  DepositFromCacheUseCase(this.repository);

  final DepositRepository repository;

  @override
  Future<Either<Failure, DepositModel>> call(NoParams params) =>
      repository.depositFromCache();
}

class PostDepositUseCase implements UseCase<bool, PostDeposit> {
  PostDepositUseCase(this.repository);

  final DepositRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostDeposit params) =>
      repository.postDeposit(params);
}
