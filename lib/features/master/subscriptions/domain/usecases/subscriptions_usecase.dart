import 'package:dartz/dartz.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/data/models/subscriptions_model.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/domain/entities/post_subscriptions.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/domain/repositories/subscriptions_repository.dart';
import 'package:kmp_pengurus_app/framework/core/exceptions/failures.dart';
import 'package:kmp_pengurus_app/framework/core/usecases/usecase.dart';

class SubscriptionsUseCase implements UseCase<SubscriptionsModel, NoParams> {
  SubscriptionsUseCase(this.repository);

  final SubscriptionsRepository repository;

  @override
  Future<Either<Failure, SubscriptionsModel>> call(NoParams params) =>
      repository.subscriptions();
}

class SubscriptionsFromCacheUseCase
    implements UseCase<SubscriptionsModel, NoParams> {
  SubscriptionsFromCacheUseCase(this.repository);

  final SubscriptionsRepository repository;

  @override
  Future<Either<Failure, SubscriptionsModel>> call(NoParams params) =>
      repository.subscriptionsFromCache();
}

class PostSubscriptionUseCase implements UseCase<bool, PostSubscriptions> {

  PostSubscriptionUseCase(this.repository);

  final SubscriptionsRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostSubscriptions params) =>
      repository.postSubscription(params);
}

class EditSubscriptionUseCase implements UseCase<bool, PostSubscriptions> {

  EditSubscriptionUseCase(this.repository);

  final SubscriptionsRepository repository;

  @override
  Future<Either<Failure, bool>> call(PostSubscriptions params) =>
      repository.editSubscription(params);
}

class DeleteSubscriptionUseCase implements UseCase<bool, String> {

  DeleteSubscriptionUseCase(this.repository);

  final SubscriptionsRepository repository;

  @override
  Future<Either<Failure, bool>> call(String params) =>
      repository.deleteSubscription(params);
}
