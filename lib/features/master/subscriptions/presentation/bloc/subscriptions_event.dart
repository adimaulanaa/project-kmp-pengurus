import 'package:equatable/equatable.dart';
import 'package:kmp_pengurus_app/features/master/subscriptions/domain/entities/post_subscriptions.dart';

abstract class SubscriptionsEvent extends Equatable {
  const SubscriptionsEvent();

  @override
  List<Object> get props => [];
}

class LoadSubscriptions extends SubscriptionsEvent {
  
}

class AddLoadSubscriptions extends SubscriptionsEvent {
  
}

class EditLoadSubscriptions extends SubscriptionsEvent {
  
}

class AddSubscriptionsEvent extends SubscriptionsEvent {
  final PostSubscriptions subscriptions;

  const AddSubscriptionsEvent({
    required this.subscriptions,
  });
}

class EditSubscriptionsEvent extends SubscriptionsEvent {
  final PostSubscriptions subscriptionsEdit;

  const EditSubscriptionsEvent({
    required this.subscriptionsEdit,
  });
}

class DeleteSubscriptionsEvent extends SubscriptionsEvent {
  final String idSubs;

  const DeleteSubscriptionsEvent({
    required this.idSubs,
  });
}
