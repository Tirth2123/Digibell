import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../utils/logger.dart';
import '../../../../api_models/api_status.dart';
import '../Repository/help_faqs_repository.dart';
import 'help_faqs_event.dart';
import 'help_faqs_state.dart';

class HelpFaqsBloc extends Bloc<HelpFaqsEvent, HelpFaqsState> {
  final _repository = GetIt.I<HelpFaqsRepository>();
  HelpFaqsBloc() : super(HelpFaqsState()) {
    on<PerformHelpFaqsEvent>(_perform);
  }

  void _perform(PerformHelpFaqsEvent event, Emitter<HelpFaqsState> emit) async {
    emit(HelpFaqsState(isLoading: true, isFailed: false));
    final response = await _repository.get();
    logger.w('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('RESPONSE_STATUS ${response.status}');
      emit(HelpFaqsState(isCompleted: true, isLoading: false, helpFaqsModel: response.data));
    } else {
      emit(HelpFaqsState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
