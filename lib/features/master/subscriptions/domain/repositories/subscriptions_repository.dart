import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/data/models/subscriptions_model.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/domain/entities/post_subscriptions.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';

abstract class SubscriptionsRepository {
  
  Future<Either<Failure, bool>> postSubscription(PostSubscriptions subscriptions);
  Future<Either<Failure, bool>> editSubscription(PostSubscriptions subscriptionsEdit);
  Future<Either<Failure, bool>> deleteSubscription(String subscriptionsDelete);
  Future<Either<Failure, SubscriptionsModel>> subscriptions();
  Future<Either<Failure, SubscriptionsModel>> subscriptionsFromCache();
}
