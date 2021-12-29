import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/data/models/deposit_model.dart';
import 'package:kmp_pengurus_app/features/bendahara/deposit/domain/entities/post_deposit.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';

abstract class DepositRepository {
  
  Future<Either<Failure, bool>> postDeposit(PostDeposit deposit);
  Future<Either<Failure, DepositModel>> deposit();
  Future<Either<Failure, DepositModel>> depositFromCache();
}
