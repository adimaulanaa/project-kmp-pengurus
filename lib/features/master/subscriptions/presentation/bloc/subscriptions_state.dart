import 'package:kmp_pengurus_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/data/models/subscriptions_model.dart';

abstract class SubscriptionsState {
  List<Object> get props => [];
}

class SubscriptionsInitial extends SubscriptionsState {}

class SubscriptionsLoading extends SubscriptionsState {}

class SubscriptionsLoaded extends SubscriptionsState {
  SubscriptionsLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  SubscriptionsModel? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}

class SubscriptionsCategoryLoaded extends SubscriptionsState {
  SubscriptionsCategoryLoaded({
    this.isFromCacheFirst = false,
    required this.listCategory,
  });

  bool isFromCacheFirst;
  final List<SubscriptionCategory> listCategory;

  @override
  List<Object> get props => [isFromCacheFirst, listCategory];
}

class AddSubscriptionsLoaded extends SubscriptionsState {
  AddSubscriptionsLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  List<Base>? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}

class EditSubscriptionsLoaded extends SubscriptionsState {
  EditSubscriptionsLoaded({
    this.isFromCacheFirst = false,
    this.data,
  });

  bool isFromCacheFirst;
  List<Base>? data;

  @override
  List<Object> get props => [isFromCacheFirst, data!];
}

class SubscriptionsSuccess extends SubscriptionsState {
  final bool isSuccess;

  SubscriptionsSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class DeleteSubscriptionsSuccess extends SubscriptionsState {
  final bool isSuccess;

  DeleteSubscriptionsSuccess({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class SubscriptionsFailure extends SubscriptionsState {
  SubscriptionsFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SubscriptionsFailure { error: $error }';
}
