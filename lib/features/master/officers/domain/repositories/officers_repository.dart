import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/master/officers/data/models/officers_model.dart';
import 'package:kmp_pengurus_app/features/master/officers/domain/entities/post_officers.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';

abstract class OfficersRepository {
  
  Future<Either<Failure, bool>> postOfficer(PostOfficers officers);
  Future<Either<Failure, bool>> editOfficer(PostOfficers officersEdit);
  Future<Either<Failure, bool>> deleteOfficer(String officersDelete);
  Future<Either<Failure, OfficersModel>> officers();
  Future<Either<Failure, OfficersModel>> officersFromCache();
}
