import 'package:Digibells/screens/ProductDetailsScreen/product_details/bloc/product_details_state.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../repository/product_details_repository.dart';
part 'product_details_event.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final _loginRepository = GetIt.I<ProductDetailsRepository>();
  ProductDetailsBloc() : super(ProductDetailsState()) {
    on<PerformProductDetailsEvent>(_perform);
  }
  void _perform(PerformProductDetailsEvent event, Emitter<ProductDetailsState> emit) async {
    emit(ProductDetailsState(isLoading: true));
    final response = await _loginRepository.productDetails(event.id);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(ProductDetailsState(
          isCompleted: true,
          // from: event.from,
          isLoading: false,
          productDetailsModel: response.data));
    } else {
      emit(ProductDetailsState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
