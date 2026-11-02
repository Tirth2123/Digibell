import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import '../../../../../api_models/api_error.dart';
import '../../../../../api_models/api_status.dart';
import '../model/product_list_model.dart';
import '../repository/product_list_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final _loginRepository = GetIt.I<ProductListRepository>();
  ProductListBloc() : super(ProductListState()) {
    on<PerformProductListEvent>(_perform);
  }
  void _perform(PerformProductListEvent event, Emitter<ProductListState> emit) async {
    emit(ProductListState(isLoading: true));
    final response = await _loginRepository.productList(event.page, event.searchQuery);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(ProductListState(isCompleted: true,
          // from: event.from,
          isLoading: false, productListModel: response.data));
    } else {
      emit(ProductListState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
