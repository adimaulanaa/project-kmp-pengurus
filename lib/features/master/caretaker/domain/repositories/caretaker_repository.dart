import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/data/models/caretaker_model.dart';
import 'package:kmp_pengurus_app/features/master/caretaker/domain/entities/post_caretaker.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';

abstract class CaretakerRepository {
  
  Future<Either<Failure, bool>> postCaretaker(PostCaretaker caretaker);
  Future<Either<Failure, bool>> editCaretaker(PostCaretaker caretakerEdit);
  
  Future<Either<Failure, CaretakerModel>> caretaker();
  Future<Either<Failure, CaretakerModel>> caretakerFromCache();
}
