part of 'product_list_bloc.dart';

@immutable
abstract class ProductListEvent {
  const ProductListEvent();
}

class PerformProductListEvent extends ProductListEvent {
  final dynamic page;
  final dynamic searchQuery;

   PerformProductListEvent({
     required this.page,
     required this.searchQuery,
  });
}
