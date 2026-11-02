part of 'product_list_bloc.dart';

@immutable
class ProductListState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final String? from;
  final bool isCompleted;
  final bool isFailed;
  final int? statusCode;
  final ProductListModel? productListModel;

  ProductListState(
      {this.isLoading = false,
        this.error,
        this.from,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.statusCode,
        this.productListModel});
}
