abstract class UpdateCartQuantityEvent {
  const UpdateCartQuantityEvent();
}

class PerformUpdateCartQuantityEvent extends UpdateCartQuantityEvent {
  final dynamic data;
  final dynamic id;

  PerformUpdateCartQuantityEvent({required this.data, required this.id});
}
