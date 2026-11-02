abstract class AddToCartEvent {
  const AddToCartEvent();
}

class PerformAddToCartEvent extends AddToCartEvent {
  final dynamic data;

  PerformAddToCartEvent({required this.data});
}
