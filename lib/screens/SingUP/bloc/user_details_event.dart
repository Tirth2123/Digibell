part of 'user_details_bloc.dart';


@immutable
abstract class UserDetailsEvent {
  const UserDetailsEvent();
}

class PerformUserDetailsEvent extends UserDetailsEvent {
  final dynamic data;

  PerformUserDetailsEvent({required this.data});
}





