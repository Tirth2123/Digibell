// @immutable
// abstract class OrderStickerScreenEvent {}

abstract class OrderStickerEvent {
  const OrderStickerEvent();
}

class PerformOrderStickerEvent extends OrderStickerEvent {
  final dynamic data;

  PerformOrderStickerEvent({required this.data});
}
