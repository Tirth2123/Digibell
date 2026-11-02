part of 'update_profile_bloc.dart';

@immutable
abstract class UpdateProfileEvent {
  const UpdateProfileEvent();
}

class PerformUpdateProfileEvent extends UpdateProfileEvent {
  final dynamic data;

  PerformUpdateProfileEvent({required this.data});
}
