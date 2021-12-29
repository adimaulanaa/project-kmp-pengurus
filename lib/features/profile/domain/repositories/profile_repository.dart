import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/profile/data/models/post_password.dart';
import 'package:kmp_pengurus_app/features/profile/data/models/profile_model.dart';
import 'package:kmp_pengurus_app/features/profile/domain/entities/post_profile.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';

abstract class ProfileRepository {
  
  Future<Either<Failure, bool>> editProfile(PostProfile officersEdit);
  Future<Either<Failure, bool>> changePassword(PostPassword changePassword);
  Future<Either<Failure, ProfileModel>> profile();
}
