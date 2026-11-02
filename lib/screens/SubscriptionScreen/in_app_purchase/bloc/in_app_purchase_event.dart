abstract class InAppPurchaseEvent {
  const InAppPurchaseEvent();
}

class PerformInAppPurchaseEvent extends InAppPurchaseEvent {
  final dynamic data;

  PerformInAppPurchaseEvent({required this.data});
}
