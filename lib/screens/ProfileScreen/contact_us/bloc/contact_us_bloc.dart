import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../repository/contact_us_repository.dart';
import 'contact_us_event.dart';
import 'contact_us_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  final _repository = GetIt.I<ContactUsRepository>();
  ContactUsBloc() : super(ContactUsState()) {
    on<PerformContactUsEvent>(_perform);
  }
  void _perform(PerformContactUsEvent event, Emitter<ContactUsState> emit) async {
    emit(ContactUsState(isLoading: true, isFailed: false));

    final response = await _repository.ContactUs(event.data);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(ContactUsState(isCompleted: true, isLoading: false, contactUsModel: response.data));
    } else {
      emit(ContactUsState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
