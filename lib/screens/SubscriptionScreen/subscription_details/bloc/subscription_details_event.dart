abstract class SubscriptionDetailsEvent {
  const SubscriptionDetailsEvent();
}

class PerformSubscriptionDetailsEvent extends SubscriptionDetailsEvent {
  final dynamic type;
  final dynamic search;

  PerformSubscriptionDetailsEvent({required this.type, required this.search});
}
