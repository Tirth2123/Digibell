abstract class UpgradePlanEvent {
  const UpgradePlanEvent();
}

class PerformUpgradePlanEvent extends UpgradePlanEvent {
  final dynamic data;

  PerformUpgradePlanEvent({required this.data});
}
