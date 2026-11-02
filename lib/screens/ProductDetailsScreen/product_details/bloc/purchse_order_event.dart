import 'package:flutter/cupertino.dart';

@immutable
abstract class PurchseOrderEvent {
  const PurchseOrderEvent();
}

class PerformPurchseOrderEvent extends PurchseOrderEvent {
  final dynamic data;

  PerformPurchseOrderEvent({required this.data});
}
