import '../../../../api_models/api_error.dart';
import '../model/product_details_model.dart';

class ProductDetailsState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final String? from;
  final bool isCompleted;
  final bool isFailed;
  final int? statusCode;
  final ProductDetailsModel? productDetailsModel;

  ProductDetailsState(
      {this.isLoading = false,
      this.error,
      this.from,
      this.errorMsg = '',
      this.isCompleted = false,
      this.isFailed = false,
      this.statusCode,
      this.productDetailsModel});
}
