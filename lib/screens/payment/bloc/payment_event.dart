abstract class PaymentEvent {
  const PaymentEvent();
}

class PerformPaymentEvent extends PaymentEvent {
  final dynamic data;

  PerformPaymentEvent({required this.data});
}
