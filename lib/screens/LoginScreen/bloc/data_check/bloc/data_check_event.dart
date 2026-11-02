part of 'data_check_bloc.dart';



@immutable
abstract class DataCheckEvent {
  const DataCheckEvent();
}

class PerformDataCheckEvent extends DataCheckEvent {
  final dynamic data;
  // final dynamic from;

  PerformDataCheckEvent({required this.data,
    // required this.from
  });
}
