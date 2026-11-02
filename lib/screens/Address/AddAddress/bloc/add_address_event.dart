import 'package:flutter/cupertino.dart';

@immutable
abstract class AddAddressEvent {
  const AddAddressEvent();
}

class PerformAddAddressEvent extends AddAddressEvent {
  final dynamic data;

  PerformAddAddressEvent({required this.data});
}
