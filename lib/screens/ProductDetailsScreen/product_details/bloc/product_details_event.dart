part of 'product_details_bloc.dart';

//
abstract class ProductDetailsEvent {
  const ProductDetailsEvent();
}

class PerformProductDetailsEvent extends ProductDetailsEvent {
  final dynamic id;

  PerformProductDetailsEvent({required this.id});
}

