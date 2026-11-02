abstract class RemoveCartItemEvent {
  const RemoveCartItemEvent();
}

class PerformRemoveCartItemEvent extends RemoveCartItemEvent {
  final dynamic id;

  PerformRemoveCartItemEvent({required this.id});
}
